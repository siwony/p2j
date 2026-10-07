import SwiftData
import SwiftUI

struct PlanAdjustmentSheet: View {
    enum Mode {
        case move(OccurrenceSnapshot, restore: Bool)
        case rest([OccurrenceSnapshot])
        case recovery([OccurrenceSnapshot])
    }
    let mode: Mode
    let today: LocalDate
    let onSaved: (LocalDate?) -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(ExecutionRecorder.self) private var recorder
    @State private var day: LocalDate
    @State private var time: LocalTime?
    @State private var selected: Set<UUID> = []
    @State private var error: String?
    @State private var confirming = false
    @State private var committed = false
    @State private var confirmingSkip = false
    @AccessibilityFocusState private var errorFocused: Bool
    @AccessibilityFocusState private var skipFocused: Bool

    init(mode: Mode, today: LocalDate, onSaved: @escaping (LocalDate?) -> Void) {
        self.mode = mode; self.today = today; self.onSaved = onSaved
        if case .move(let source, _) = mode {
            _day = State(initialValue: source.day); _time = State(initialValue: source.time)
        } else { _day = State(initialValue: today) }
    }
    private var title: String {
        switch mode { case .move(_, let restore): restore ? "다시 계획하기" : "일정 옮기기"
        case .rest: "남은 일정 쉬기"
        case .recovery: "이번 주 계획 다시 고르기" }
    }
    private var dirty: Bool {
        switch mode {
        case .move(let source, _): day != source.day || time != source.time
        case .recovery: !selected.isEmpty || day != today
        case .rest: false
        }
    }
    private var canSave: Bool { if case .recovery = mode { return !selected.isEmpty }; return true }
    var body: some View {
        NavigationStack {
            Form {
                if let error { Section { Text(error).accessibilityIdentifier("week.error").accessibilityFocused($errorFocused) } }
                switch mode {
                case .move(let source, let restore):
                    Section(source.name) {
                        Text("현재 \(source.day.fullLabel)").foregroundStyle(DesignTokens.textSecondary)
                        PlanDateFields(day: $day, time: $time)
                        if day.monday != source.day.monday { Text("\(day.monday.fullLabel)부터 시작하는 주로 옮겨요.") }
                    }
                    if !restore {
                        Section {
                            Button("이번 주 건너뛰기") { confirmingSkip = true }
                                .disabled(committed).accessibilityFocused($skipFocused)
                                .confirmationDialog("이번 주에서는 건너뛸까요?", isPresented: $confirmingSkip, titleVisibility: .visible) {
                                    Button("건너뛰기", action: skip)
                                    Button("취소", role: .cancel) { skipFocused = true }
                                }
                        }
                    }
                case .rest(let sources):
                    Section {
                        Text("아래 일정만 쉬기로 표시해요. 완료한 일은 그대로 남고, 새 일정은 언제든 담을 수 있어요.")
                        ForEach(sources) { source in
                            VStack(alignment: .leading) { Text(source.name); Text("\(source.day.label) · \(source.statusLabel)").font(.subheadline).foregroundStyle(DesignTokens.textSecondary) }
                        }
                    }
                case .recovery(let sources):
                    Section("다시 고를 일정") {
                        Text("원하는 일만 골라주세요.").foregroundStyle(DesignTokens.textSecondary)
                        ForEach(sources) { source in
                            Toggle("\(source.name) · \(source.day.label)", isOn: selectedBinding(source.id))
                                .accessibilityIdentifier("week.recover.\(source.id)")
                        }
                    }
                    Section("새 날짜") {
                        Picker("옮길 날짜", selection: $day) {
                            ForEach(today.weekDays.filter { $0 >= today }) { date in Text(date.label).tag(date) }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden).background(DesignTokens.background)
            .navigationTitle(title).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { if dirty { confirming = true } else { dismiss() } }
                }
                ToolbarItem(placement: .confirmationAction) { Button(saveLabel, action: save).disabled(!canSave || committed) }
            }
            .modifier(PlanDismissal(dirty: dirty, onDiscard: { dismiss() }, confirming: $confirming))
            .onChange(of: confirmingSkip) { if !confirmingSkip { skipFocused = true } }
        }
    }
    private var saveLabel: String { if case .rest = mode { return "쉬기로 하기" }; return "저장" }
    private func selectedBinding(_ id: UUID) -> Binding<Bool> {
        Binding(get: { selected.contains(id) }, set: { if $0 { selected.insert(id) } else { selected.remove(id) } })
    }
    private func save() {
        guard !committed else { return }
        do {
            let currentDay = LocalDate(.now)
            switch mode {
            case .move(let source, let restore):
                try PlanWriter.move(source, to: day, time: time, restore: restore, in: context)
                onSaved(day)
            case .rest(let sources):
                try PlanWriter.rest(sources, today: currentDay, in: context)
                onSaved(nil)
            case .recovery(let sources):
                try PlanWriter.replan(sources.filter { selected.contains($0.id) }, to: day, today: currentDay, in: context)
                onSaved(day)
            }
            recorder.refresh(); committed = true; dismiss()
        } catch { self.error = error.localizedDescription; errorFocused = true }
    }
    private func skip() {
        guard !committed, case .move(let source, false) = mode else { return }
        do {
            try PlanWriter.skip(source, in: context)
            recorder.refresh(); committed = true; onSaved(nil); dismiss()
        } catch { self.error = error.localizedDescription; errorFocused = true }
    }
}
