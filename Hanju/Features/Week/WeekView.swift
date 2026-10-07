import SwiftData
import SwiftUI

struct WeekRequest: Identifiable, Equatable {
    enum Kind { case plan, recovery }
    let id = UUID()
    let kind: Kind
    let day: LocalDate
}

struct WeekView: View {
    @Binding var selectedDay: LocalDate
    @Binding var request: WeekRequest?
    let returnToToday: () -> Void
    let openLibrary: () -> Void
    @Environment(\.modelContext) private var context
    @Environment(ExecutionRecorder.self) private var recorder
    @Environment(\.scenePhase) private var scenePhase
    @State private var today = LocalDate(.now)
    @State private var rows: [OccurrenceSnapshot] = []
    @State private var completedRecords: [UUID: ExecutionSnapshot] = [:]
    @State private var error: String?
    @State private var completedNotice: UUID?
    @State private var editor: Editor?
    @State private var callerDay: LocalDate?
    @State private var fromToday = false
    @State private var savedDay: LocalDate?
    @State private var succeeded = false
    @State private var skipTarget: OccurrenceSnapshot?
    @State private var showSkip = false
    @State private var restNoticeWeek: LocalDate?
    private struct RunningRoute: Hashable { let id: UUID }
    @State private var runningRoute: RunningRoute?
    @State private var pendingStart: ExecutionSnapshot?
    @State private var replacing: ExecutionSnapshot?
    @State private var confirmSwitch = false
    @AccessibilityFocusState private var focused: Focus?
    @State private var callerFocus: Focus = .plan
    private enum Focus: Hashable { case plan, rest, day, row(UUID) }
    private struct Editor: Identifiable {
        enum Kind { case plan, adjustment(PlanAdjustmentSheet.Mode), completion(ExecutionSnapshot) }
        let id = UUID()
        let kind: Kind
    }
    private var week: LocalDate { selectedDay.monday }
    private var unfinished: [OccurrenceSnapshot] { rows.filter(\.isUnfinished) }
    private var recovery: [OccurrenceSnapshot] { rows.filter { $0.day < today && $0.day.monday == today.monday && $0.canReplan } }

    var body: some View {
        List {
            Section {
                Text("\(week.fullLabel) – \(week.adding(days: 6).label)").font(.headline)
                HStack {
                    Button("지난주", systemImage: "chevron.left") { selectedDay = selectedDay.adding(days: -7) }
                    Spacer()
                    Button("이번 주") { selectedDay = today }
                    Spacer()
                    Button("다음 주", systemImage: "chevron.right") { selectedDay = selectedDay.adding(days: 7) }
                }.buttonStyle(.borderless)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(week.weekDays) { day in
                            Button { selectedDay = day } label: {
                                VStack {
                                    Text(LocalDate.dayNames[day.weekday - 1]); Text("\(day.day)")
                                    Image(systemName: "circle.fill").font(.caption2)
                                        .opacity(rows.contains(where: { $0.day == day }) ? 1 : 0)
                                        .accessibilityHidden(true)
                                }
                                    .padding(8)
                            }
                            .buttonStyle(.bordered)
                            .tint(selectedDay == day ? DesignTokens.accent : DesignTokens.textSecondary)
                            .accessibilityLabel(day.fullLabel)
                            .accessibilityValue(rows.contains(where: { $0.day == day }) ? "계획 있음" : "계획 없음")
                            .accessibilityAddTraits(selectedDay == day ? [.isSelected] : [])
                            .accessibilityIdentifier("week.day.\(day.weekday)")
                        }
                    }
                }
                .accessibilityFocused($focused, equals: .day)
            }
            if let error {
                Section { Text(error); Button("다시 시도", action: load) }
            }
            Section(selectedDay.label) {
                Text(DayWorkload.label(rows.filter { $0.day == selectedDay && $0.isUnfinished }.map(\.expectedMinutes)))
                    .font(.subheadline).foregroundStyle(DesignTokens.textSecondary)
                if rows.filter({ $0.day == selectedDay }).isEmpty { Text("이 날은 비워두었어요.").foregroundStyle(DesignTokens.textSecondary) }
                ForEach(rows.filter { $0.day == selectedDay }) { row in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(row.name).font(.headline)
                        Text(rowDescription(row)).font(.subheadline).foregroundStyle(DesignTokens.textSecondary)
                        if let explanation = row.time?.resolve(on: row.day, in: .current)?.explanation { Text(explanation).font(.footnote) }
                        if row.status == .skipped {
                            Button("다시 계획하기") { show(.adjustment(.move(row, restore: true)), focus: .row(row.id)) }
                        } else if row.isUnfinished {
                            ViewThatFits(in: .horizontal) {
                                HStack { rowActions(row) }
                                VStack(alignment: .leading) { rowActions(row) }
                            }
                        } else if row.status == .completed {
                            Button("기록 편집") { editCompletion(row.id) }
                        }
                    }
                    .accessibilityIdentifier("week.row.\(row.id)")
                    .accessibilityFocused($focused, equals: .row(row.id))
                }
            }
            if let id = completedNotice {
                Section { Text("완료했어요."); Button("기록 편집") { editCompletion(id) } }
            }
            if rows.contains(where: { $0.status == .skipped }) {
                Section {
                    if restNoticeWeek == week && unfinished.isEmpty { Text("이번 주 남은 일정은 쉬기로 했어요.") }
                    DisclosureGroup("쉬기로 한 일정 보기") {
                        ForEach(rows.filter { $0.status == .skipped }) { row in
                            VStack(alignment: .leading) {
                                Text("\(row.name) · \(row.day.label)")
                                Button("다시 계획하기") { show(.adjustment(.move(row, restore: true)), focus: .row(row.id)) }
                            }
                        }
                    }
                }
            }
            Section {
                if rows.isEmpty { Text("이번 주에 할 일을 골라볼까요?") }
                Button(rows.isEmpty ? "루틴 선택" : "루틴 추가") { show(.plan, focus: .plan) }
                    .accessibilityIdentifier("week.plan")
                    .accessibilityFocused($focused, equals: .plan)
                Button("루틴함 보기", action: openLibrary)
                if week == today.monday {
                    if !unfinished.isEmpty {
                        Button("이번 주 남은 일정 쉬기") { show(.adjustment(.rest(unfinished)), focus: .rest) }
                            .accessibilityFocused($focused, equals: .rest)
                    } else if rows.isEmpty {
                        Button("이번 주 쉬기", action: returnToToday)
                    }
                }
            }
        }
        .listStyle(.plain).scrollContentBackground(.hidden).background(DesignTokens.background)
        .navigationTitle("이번 주")
        .navigationDestination(item: $runningRoute) { route in RunningRoutineView(occurrenceID: route.id, returnLabel: "이번 주로 돌아가기") }
        .sheet(item: $editor, onDismiss: didDismiss) { item in
            switch item.kind {
            case .plan:
                WeeklySelectionSheet(week: week, earliest: max(week, week == today.monday ? today : week), existing: rows, onSaved: saved)
            case .completion(let source):
                CompletionSheet(source: source)
            case .adjustment(let mode):
                PlanAdjustmentSheet(mode: mode, today: today, onSaved: saved)
            }
        }
        .confirmationDialog("이번 주에서는 건너뛸까요?", isPresented: $showSkip, titleVisibility: .visible) {
            Button("건너뛰기", action: confirmSkip)
            Button("취소", role: .cancel) { if let skipTarget { focused = .row(skipTarget.id) } }
        }
        .confirmationDialog("하던 일을 일시정지하고 시작할까요?", isPresented: $confirmSwitch, titleVisibility: .visible) {
            Button("일시정지하고 시작") { if let pendingStart { resume(pendingStart, replacing: replacing) } }
            Button("취소", role: .cancel) { if let pendingStart { focused = .row(pendingStart.id) } }
        } message: { if let replacing { Text(replacing.occurrence.name) } }
        .onAppear { refreshClock(); consumeRequest() }
        .onChange(of: selectedDay) { load() }
        .onChange(of: runningRoute) { if runningRoute == nil { focused = callerFocus } }
        .onChange(of: recorder.revision) { load() }
        .onChange(of: request) { consumeRequest() }
        .onChange(of: scenePhase) { if scenePhase == .active { refreshClock() } }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in refreshClock() }
        .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in refreshClock() }
    }
    @ViewBuilder private func rowActions(_ row: OccurrenceSnapshot) -> some View {
        if row.status == .paused {
            Button("이어서 하기") { start(row.id) }.buttonStyle(.borderless)
        }
        if row.canReplan {
            Button("이미 했어요") {
                do { try recorder.complete(recorder.read(row.id)); completedNotice = row.id; load() }
                catch { self.error = error.localizedDescription }
            }.buttonStyle(.borderless)
        }
        Button("옮기기") { show(.adjustment(.move(row, restore: false)), focus: .row(row.id)) }
            .buttonStyle(.borderless)
        Button("건너뛰기") { skipTarget = row; showSkip = true }
            .buttonStyle(.borderless)
    }
    private func start(_ id: UUID) {
        do {
            let source = try recorder.read(id)
            if let active = recorder.active, active.id != id {
                pendingStart = source; replacing = active; confirmSwitch = true
            } else { resume(source) }
        } catch { self.error = error.localizedDescription }
    }
    private func resume(_ source: ExecutionSnapshot, replacing active: ExecutionSnapshot? = nil) {
        do { try recorder.start(source, replacing: active); callerFocus = .row(source.id); runningRoute = RunningRoute(id: source.id); load() }
        catch { self.error = error.localizedDescription; focused = .row(source.id) }
    }
    private func editCompletion(_ id: UUID) {
        do {
            let source = try recorder.read(id)
            guard source.occurrence.status == .completed else { completedNotice = nil; throw ExecutionError.changed }
            show(.completion(source), focus: .row(id))
        }
        catch { self.error = error.localizedDescription }
    }
    private func rowDescription(_ row: OccurrenceSnapshot) -> String {
        let status = row.status == .planned && row.day.monday < today.monday ? "기록 없음" : row.statusLabel
        let duration = row.status == .completed ? completedRecords[row.id]?.duration(at: recorder.now()).label : row.expectedMinutes.map { "예상 \($0)분" }
        return [row.time?.label, duration, status].compactMap { $0 }.joined(separator: " · ")
    }
    private func show(_ kind: Editor.Kind, focus: Focus) {
        succeeded = false; savedDay = nil; fromToday = false; callerDay = nil
        callerFocus = focus; editor = Editor(kind: kind)
    }
    private func consumeRequest() {
        guard let request else { return }
        callerDay = selectedDay; fromToday = true; succeeded = false; savedDay = nil
        today = LocalDate(.now); selectedDay = request.day; load()
        editor = Editor(kind: request.kind == .plan ? .plan : .adjustment(.recovery(recovery)))
        self.request = nil
    }
    private func saved(_ day: LocalDate?) {
        succeeded = true; savedDay = day
        if case .adjustment(.rest) = editor?.kind { restNoticeWeek = week }
    }
    private func confirmSkip() {
        guard let skipTarget else { return }
        do { try PlanWriter.skip(skipTarget, in: context); recorder.refresh(); load(); focused = .row(skipTarget.id) }
        catch { self.error = error.localizedDescription }
    }
    private func didDismiss() {
        if succeeded, let savedDay { selectedDay = savedDay }
        else if fromToday, let callerDay { selectedDay = callerDay }
        load()
        focused = succeeded ? .day : callerFocus
        if fromToday && !succeeded { returnToToday() }
        fromToday = false; callerDay = nil
    }
    private func refreshClock() { today = LocalDate(.now); load() }
    private func load() {
        do {
            let loaded = try PlanWriter.fetch(week: week, in: context)
            let records = try loaded.filter { $0.status == .completed }.map { try recorder.read($0.id) }
            rows = loaded; completedRecords = Dictionary(uniqueKeysWithValues: records.map { ($0.id, $0) })
            if let completedNotice, !rows.contains(where: { $0.id == completedNotice && $0.status == .completed }) { self.completedNotice = nil }
            error = nil
        }
        catch { self.error = error.localizedDescription }
    }
}
