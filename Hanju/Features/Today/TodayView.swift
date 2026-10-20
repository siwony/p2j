import SwiftData
import SwiftUI

struct TodayView: View {
    let openWeek: (LocalDate) -> Void
    let plan: (LocalDate) -> Void
    let recover: (LocalDate) -> Void
    let openLibrary: () -> Void
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    @Environment(NotificationCoordinator.self) private var notifications
    @State private var consumedNotificationID: UUID?
    @State private var notificationTargets: [ExecutionSnapshot] = []
    @State private var startingNotification: NotificationRoute?
    @Environment(ExecutionRecorder.self) private var recorder
    @State private var isVisible = false
    @State private var today = LocalDate(.now)
    @State private var rows: [OccurrenceSnapshot] = []
    @State private var completed: [ExecutionSnapshot] = []
    @State private var error: String?
    private struct RunningRoute: Hashable { let id: UUID }
    @State private var runningRoute: RunningRoute?
    private enum Editor: Identifiable {
        case completion(ExecutionSnapshot), move(OccurrenceSnapshot)
        var id: UUID { switch self { case .completion(let source): source.id; case .move(let source): source.id } }
    }
    @State private var editing: Editor?
    @State private var movedDay: LocalDate?
    @State private var pendingStart: ExecutionSnapshot?
    @State private var replacing: ExecutionSnapshot?
    @State private var confirmSwitch = false
    @State private var completedNotice: UUID?
    @AccessibilityFocusState private var focused: UUID?
    @AccessibilityFocusState private var weekLinkFocused: Bool
    @State private var caller: UUID?

    var body: some View {
        List {
            Section { Text(today.fullLabel).font(.headline) }
            if let route = notifications.route, !route.ticket.isPlanning {
                Section("알림에서 선택한 일") {
                    ForEach(notificationTargets) { source in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(source.occurrence.name).font(.headline)
                            Text("원래 계획한 날짜 · \(source.occurrence.day.fullLabel)")
                                .font(.subheadline).foregroundStyle(DesignTokens.textSecondary)
                            Button { startNotification(source.id, route: route) } label: {
                                Text("시작").frame(minWidth: 44, minHeight: 44, alignment: .leading).contentShape(Rectangle())
                            }
                            .buttonStyle(.borderless).accessibilityIdentifier("notifications.start.\(source.id)")
                        }
                    }
                    if notificationTargets.isEmpty { Text("현재 시작할 수 있는 일이 없어요. 계획이 변경됐을 수 있어요.") }
                    Button("닫기") { notifications.dismissRoute() }
                }.accessibilityIdentifier("notifications.targets")
            }
            if let message = notifications.message { Section { Text(message) } }
            if let error = error ?? recorder.failure { Section { Text(error); Button("다시 시도") { recorder.refresh(); load() } } }
            if let active = recorder.active {
                Section {
                    VStack(alignment: .leading, spacing: DesignTokens.spacing) {
                        Text(active.occurrence.name).font(.headline)
                        Text("실행 중 · 계획한 날짜 \(active.occurrence.day.label)")
                        TimelineView(.periodic(from: .now, by: 1)) { _ in
                            Text(active.duration(at: recorder.now()).label).monospacedDigit()
                        }
                        ViewThatFits(in: .horizontal) {
                            HStack { activeActions(active) }
                            VStack(alignment: .leading) { activeActions(active) }
                        }
                    }
                    .padding(.vertical, 8).accessibilityIdentifier("execution.active")
                }.listRowBackground(DesignTokens.accentSubtle)
            }
            Section("예정") {
                let scheduled = rows.filter { $0.day == today && $0.canReplan }
                if scheduled.isEmpty && recorder.active == nil { Text("오늘은 정해둔 일이 없어요.").font(.title2) }
                ForEach(scheduled) { row in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(row.name).font(.headline)
                        Text([row.time?.label, row.expectedMinutes.map { "예상 \($0)분" }, row.statusLabel].compactMap { $0 }.joined(separator: " · "))
                            .font(.subheadline).foregroundStyle(DesignTokens.textSecondary)
                        if let firstAction = row.firstAction { Text(firstAction).font(.subheadline) }
                        ViewThatFits(in: .horizontal) {
                            HStack { scheduledActions(row) }
                            VStack(alignment: .leading) { scheduledActions(row) }
                        }
                    }.accessibilityIdentifier("today.row.\(row.id)").accessibilityFocused($focused, equals: row.id)
                }
                Button("이번 주 보기") { openWeek(today) }.accessibilityFocused($weekLinkFocused)
                if rows.isEmpty { Button("남은 이번 주 계획하기") { plan(today) } }
                Button("루틴 만들러 가기", action: openLibrary)
            }
            if rows.contains(where: { $0.day < today && $0.canReplan }) {
                Section { Button("이번 주 계획 다시 고르기") { recover(today) } }
            }
            if !completed.isEmpty {
                Section("완료한 일") {
                    ForEach(completed) { source in
                        Button { edit(source.id) } label: {
                            VStack(alignment: .leading) {
                                Label(source.occurrence.name, systemImage: "checkmark")
                                Text(source.duration(at: recorder.now()).label).font(.subheadline).foregroundStyle(DesignTokens.textSecondary)
                            }
                        }.accessibilityIdentifier("today.completed.\(source.id)").accessibilityFocused($focused, equals: source.id)
                    }
                }
            }
            if let id = completedNotice {
                Section { Text("완료했어요."); Button("기록 편집") { edit(id) } }
            }
            if today.weekday == 7 { Section { Button("다음 주 계획하기") { plan(today.adding(days: 1)) } } }
        }
        .listStyle(.plain).scrollContentBackground(.hidden).background(DesignTokens.background)
        .navigationTitle("오늘")
        .navigationDestination(item: $runningRoute) { route in RunningRoutineView(occurrenceID: route.id) }
        .sheet(item: $editing, onDismiss: {
            load()
            if rows.contains(where: { $0.id == caller && $0.day == today && $0.canReplan }) || completed.contains(where: { $0.id == caller }) { focused = caller }
            else { weekLinkFocused = true }
            if let movedDay { openWeek(movedDay); self.movedDay = nil }
        }) { item in
            switch item {
            case .completion(let source): CompletionSheet(source: source)
            case .move(let source): PlanAdjustmentSheet(mode: .move(source, restore: false), today: today, onSaved: { movedDay = $0 })
            }
        }
        .confirmationDialog("하던 일을 일시정지하고 시작할까요?", isPresented: $confirmSwitch, titleVisibility: .visible) {
            Button("일시정지하고 시작") {
                guard let pendingStart else { return }
                perform {
                    if let startingNotification { try notifications.start(pendingStart.id, from: startingNotification, replacing: replacing) }
                    else { try recorder.start(pendingStart, replacing: replacing) }
                    runningRoute = RunningRoute(id: pendingStart.id); startingNotification = nil
                }
            }
            Button("취소", role: .cancel) { focused = pendingStart?.id; startingNotification = nil }
        } message: { if let replacing { Text(replacing.occurrence.name) } }
        .notificationPresentation(owner: "today", blocked: editing != nil || confirmSwitch)
        .onAppear { isVisible = true; recorder.refresh(); load(); consumeNotification() }
        .onDisappear { isVisible = false; notifications.setVisibleTargets(owner: "today", ids: []) }
        .onChange(of: notifications.route?.id) { consumeNotification() }
        .onChange(of: recorder.revision) { load() }
        .onChange(of: scenePhase) { if scenePhase == .active { recorder.refresh(); load() } }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in recorder.refresh(); load() }
        .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in recorder.refresh(); load() }
    }
    @ViewBuilder private func activeActions(_ source: ExecutionSnapshot) -> some View {
        Button("실행 상세") { runningRoute = RunningRoute(id: source.id) }.buttonStyle(.borderless)
        Button("일시정지") { perform { try recorder.pause(source) } }.buttonStyle(.borderless)
        Button("완료") { complete(source.id) }.buttonStyle(.borderless)
    }
    @ViewBuilder private func scheduledActions(_ row: OccurrenceSnapshot) -> some View {
        Button(row.status == .paused ? "이어서 하기" : "시작") { start(row.id) }.buttonStyle(.borderless)
        Button("이미 했어요") { complete(row.id) }.buttonStyle(.borderless)
        Button("옮기기") { caller = row.id; movedDay = nil; editing = .move(row) }.buttonStyle(.borderless)
    }
    private func start(_ id: UUID) {
        startingNotification = nil
        perform {
            let source = try recorder.read(id)
            if let active = recorder.active, active.id != id {
                pendingStart = source; replacing = active; confirmSwitch = true
            } else { try recorder.start(source); runningRoute = RunningRoute(id: id) }
        }
    }
    private func consumeNotification() {
        guard let route = notifications.route, !route.ticket.isPlanning else { notificationTargets = []; return }
        guard consumedNotificationID != route.id else { return }
        consumedNotificationID = route.id
        runningRoute = nil // Reveal this explicit request without pausing the existing timer.
        perform {
            notificationTargets = try notifications.targets(for: route)
            if route.action == .start, route.ticket.targets.count == 1, notificationTargets.count == 1, let source = notificationTargets.first {
                startNotification(source.id, route: route)
            }
        }
    }
    private func startNotification(_ id: UUID, route: NotificationRoute) {
        perform {
            guard let source = try notifications.targets(for: route).first(where: { $0.id == id }) else { throw NotificationFailure.changed }
            if let active = recorder.active, active.id != id {
                pendingStart = source; replacing = active; startingNotification = route; confirmSwitch = true
            } else {
                try notifications.start(id, from: route); runningRoute = RunningRoute(id: id)
            }
        }
    }
    private func complete(_ id: UUID) {
        perform { try recorder.complete(recorder.read(id)); completedNotice = id }
    }
    private func edit(_ id: UUID) {
        perform {
            let source = try recorder.read(id)
            guard source.occurrence.status == .completed else { completedNotice = nil; throw ExecutionError.changed }
            caller = id; editing = .completion(source)
        }
    }
    private func perform(_ action: () throws -> Void) { do { try action(); load() } catch { self.error = error.localizedDescription } }
    private func load() {
        today = LocalDate(.now)
        do { rows = try PlanWriter.fetch(week: today.monday, in: context); completed = try recorder.completed(on: today)
            if let completedNotice, !completed.contains(where: { $0.id == completedNotice }) { self.completedNotice = nil }
            if let route = notifications.route, !route.ticket.isPlanning {
                notificationTargets = try notifications.targets(for: route)
            } else { notificationTargets = [] }
            error = nil
            if isVisible { notifications.setVisibleTargets(owner: "today", ids: Set(rows.filter { $0.day == today }.map(\.id))) } }
        catch { self.error = error.localizedDescription }
    }
}
