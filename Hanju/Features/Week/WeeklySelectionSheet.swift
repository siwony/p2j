import SwiftData
import SwiftUI

struct WeeklySelectionSheet: View {
    let week: LocalDate
    let earliest: LocalDate
    let existing: [OccurrenceSnapshot]
    let onSaved: (LocalDate) -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var draft: PlanDraft
    @State private var routines: [RoutineSnapshot] = []
    @State private var previous: [OccurrenceSnapshot] = []
    @State private var selected: Set<UUID> = []
    @State private var counts: [UUID: String] = [:]
    @State private var selectedPrevious: Set<UUID> = []
    @State private var error: String?
    @State private var confirming = false
    @State private var committed = false
    @State private var returnCountFocus: UUID?
    @FocusState private var countFocused: UUID?
    @AccessibilityFocusState private var errorFocused: Bool

    init(week: LocalDate, earliest: LocalDate, existing: [OccurrenceSnapshot], onSaved: @escaping (LocalDate) -> Void) {
        self.week = week; self.earliest = earliest; self.existing = existing; self.onSaved = onSaved
        _draft = State(initialValue: PlanDraft(week: week))
    }
    private var dirty: Bool { !draft.entries.isEmpty || !selected.isEmpty || !selectedPrevious.isEmpty }
    private var lastDay: LocalDate { week.adding(days: 6) }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
            Form {
                Section {
                    Text("\(week.fullLabel) – \(lastDay.label)").font(.headline)
                    Text("담기 전에는 일정이 만들어지지 않아요.").foregroundStyle(DesignTokens.textSecondary)
                }
                if let error { Section { Text(error).foregroundStyle(DesignTokens.textSecondary).accessibilityIdentifier("week.error").accessibilityFocused($errorFocused).id("week.error") } }
                if !existing.isEmpty {
                    Section("이미 담은 일정") {
                        ForEach(existing) { item in
                            VStack(alignment: .leading) { Text(item.name); Text("\(item.day.label) · \(item.statusLabel)").font(.subheadline).foregroundStyle(DesignTokens.textSecondary) }
                        }
                    }
                }
                if draft.entries.isEmpty {
                    Section("루틴 고르기") {
                        if routines.isEmpty { Text("루틴함에서 반복할 일을 먼저 적어주세요.") }
                        ForEach(routines) { routine in
                            Toggle(routine.draft.name, isOn: selectedBinding(routine.id))
                                .accessibilityIdentifier("week.choose.\(routine.id)")
                            if selected.contains(routine.id) {
                                LabeledContent("횟수") {
                                    TextField("횟수", text: countBinding(routine.id))
                                        .keyboardType(.numberPad).focused($countFocused, equals: routine.id)
                                        .multilineTextAlignment(.trailing)
                                        .accessibilityLabel("\(routine.draft.name) 횟수")
                                }
                            }
                        }
                    }
                    Section {
                        Button("지난 계획 가져오기", action: loadPrevious)
                        ForEach(previous) { item in
                            Toggle("\(item.name) · \(item.day.label)", isOn: previousBinding(item.id))
                        }
                    } footer: { Text("지난주에서 고른 회차만 새 일정으로 담아요. 선택하지 않은 일은 따라오지 않아요.") }
                    Section { Button("회차 배치", action: allocate).disabled(selected.isEmpty && selectedPrevious.isEmpty) }
                } else {
                    Section("요일별 예상 시간") {
                        ForEach(earliest.weekDays.filter { $0 >= earliest }) { day in
                            Text("\(day.label) · \(DayWorkload.label(existing.filter { $0.day == day && $0.isUnfinished }.map(\.expectedMinutes) + draft.entries.filter { $0.day == day }.map(\.expectedMinutes)))")
                        }
                    }
                    ForEach($draft.entries) { $entry in
                        Section(entry.name) {
                            PlanDateFields(day: $entry.day, time: $entry.time, range: earliest...lastDay)
                            Button("이 회차 빼기", role: .destructive) { draft.entries.removeAll { $0.id == entry.id } }
                        }
                    }
                    Section { Button("선택부터 다시 고르기") { draft.entries = [] } }
                }
            }
            .scrollContentBackground(.hidden).background(DesignTokens.background)
            .navigationTitle("주간 계획")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("취소", action: cancel) }
                ToolbarItem(placement: .confirmationAction) {
                    Button("계획에 담기", action: save).disabled(draft.entries.isEmpty || committed)
                }
                ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("입력 완료") { countFocused = nil } }
            }
            .modifier(PlanDismissal(dirty: dirty, onDiscard: { dismiss() }, confirming: $confirming))
            .task { loadRoutines() }
            .onChange(of: error) { if error != nil { proxy.scrollTo("week.error", anchor: .top) } }
            .onChange(of: confirming) {
                if confirming { returnCountFocus = countFocused; countFocused = nil }
                else { countFocused = returnCountFocus }
            }
            }
        }
    }
    private func selectedBinding(_ id: UUID) -> Binding<Bool> {
        Binding(get: { selected.contains(id) }, set: { if $0 { selected.insert(id) } else { selected.remove(id) } })
    }
    private func previousBinding(_ id: UUID) -> Binding<Bool> {
        Binding(get: { selectedPrevious.contains(id) }, set: { if $0 { selectedPrevious.insert(id) } else { selectedPrevious.remove(id) } })
    }
    private func countBinding(_ id: UUID) -> Binding<String> { Binding(get: { counts[id] ?? "1" }, set: { counts[id] = $0 }) }
    private func loadRoutines() {
        do {
            routines = try RoutineWriter.fetch(in: context, archived: false)
            for routine in routines where counts[routine.id] == nil { counts[routine.id] = routine.draft.weeklyFrequencyText.isEmpty ? "1" : routine.draft.weeklyFrequencyText }
        } catch { show(error) }
    }
    private func loadPrevious() {
        do {
            let activeIDs = Set(try RoutineWriter.fetch(in: context, archived: false).map(\.id))
            previous = try PlanWriter.fetch(week: week.adding(days: -7), in: context).filter { activeIDs.contains($0.routineID) }
            if previous.isEmpty { error = "지난주에 담은 계획이 없어요." }
        } catch { show(error) }
    }
    private func allocate() {
        do {
            draft = try PlanDraft.allocate(week: week, earliest: earliest,
                routines: routines.filter { selected.contains($0.id) }, counts: counts,
                previous: previous.filter { selectedPrevious.contains($0.id) })
            error = nil; countFocused = nil
        } catch { show(error) }
    }
    private func save() {
        guard !committed else { return }
        do {
            let now = LocalDate(.now)
            if week == now.monday, draft.entries.contains(where: { $0.day < now }) { throw PlanError.invalidDate }
            try PlanWriter.confirm(draft, in: context)
            committed = true; onSaved(draft.entries.first?.day ?? earliest); dismiss()
        } catch { show(error) }
    }
    private func show(_ failure: Error) { error = failure.localizedDescription; errorFocused = true }
    private func cancel() { if dirty { confirming = true } else { dismiss() } }
}

enum DayWorkload {
    static func label(_ values: [Int?]) -> String {
        if values.isEmpty { return "계획 없음" }
        var sum = 0
        for value in values.compactMap({ $0 }) {
            let (newValue, overflow) = sum.addingReportingOverflow(value)
            if overflow { return "예상 시간 합계가 표시 범위를 넘었어요" }
            sum = newValue
        }
        if values.allSatisfy({ $0 == nil }) { return "예상 시간 미정" }
        return "예상 \(sum)분" + (values.contains(where: { $0 == nil }) ? " · 예상 시간 미정 포함" : "")
    }
}
