import Foundation
import Observation
import SwiftData

@MainActor @Observable
final class NotificationCoordinator {
    private(set) var state = NotificationPersistentState()
    private(set) var loaded = false
    private(set) var message: String?
    private(set) var authorization: NotificationSystemSnapshot.Authorization = .unknown
    private(set) var scheduledCount = 0
    private(set) var waitingForTime = 0
    private(set) var waitingForCapacity = 0
    private(set) var needsRetry = false
    private(set) var route: NotificationRoute?
    private(set) var deferred = false
    private(set) var reconciling = false
    @ObservationIgnored private let store: NotificationStateStore
    @ObservationIgnored private let client: any NotificationClient
    @ObservationIgnored private let startCommand: ((ExecutionSnapshot, ExecutionSnapshot?) throws -> Void)?
    @ObservationIgnored private let now: () -> Date
    @ObservationIgnored private let timeZone: () -> TimeZone
    @ObservationIgnored private var container: ModelContainer?
    @ObservationIgnored private var recorder: ExecutionRecorder?
    @ObservationIgnored private var observer: NSObjectProtocol?
    @ObservationIgnored private var generation = 0
    @ObservationIgnored private var blockers = Set<String>()
    @ObservationIgnored private var planningVisible = false
    @ObservationIgnored private var visibleTargets: [String: Set<UUID>] = [:]
    @ObservationIgnored private var responses: [NotificationEnvelope] = []

    init(store: NotificationStateStore = .applicationStore, client: any NotificationClient = SystemNotificationClient(),
         startCommand: ((ExecutionSnapshot, ExecutionSnapshot?) throws -> Void)? = nil,
         now: @escaping () -> Date = { .now }, timeZone: @escaping () -> TimeZone = { .current }) {
        self.store = store; self.client = client; self.startCommand = startCommand; self.now = now; self.timeZone = timeZone
    }
    func attach(container: ModelContainer, recorder: ExecutionRecorder) {
        guard self.container == nil else { return }
        self.container = container; self.recorder = recorder
        let identity = ObjectIdentifier(container)
        observer = NotificationCenter.default.addObserver(forName: ModelContext.didSave, object: nil, queue: nil) { [weak self] note in
            // Only a primitive identity crosses isolation; the context stays in the posting callback.
            guard let context = note.object as? ModelContext, ObjectIdentifier(context.container) == identity else { return }
            Task { @MainActor [weak self] in self?.requestReconcile() }
        }
        reloadState()
        NotificationInbox.shared.attach { [weak self] in self?.accept($0) }
    }
    func reloadState() {
        do { state = try store.load(); loaded = true; message = nil; requestReconcile() }
        catch { loaded = false; needsRetry = true; message = NotificationFailure.state.localizedDescription }
    }
    func retry() { if loaded { requestReconcile() } else { reloadState() } }

    /// Called only after the Settings explanation's explicit confirmation, never on launch.
    @discardableResult
    func updatePreferences(_ preferences: NotificationPreferences, requestPermission: Bool = false) async -> Bool {
        guard loaded else { return false }
        do {
            var changed = state; changed.preferences = preferences
            try install(changed) // No OS calls if this write fails.
            generation += 1
            if requestPermission { try await client.authorize() }
            requestReconcile()
            return true
        } catch { message = error.localizedDescription; needsRetry = true; return false }
    }
    func requestReconcile() {
        guard loaded, container != nil else { return }
        generation += 1
        guard !reconciling else { return }
        reconciling = true
        Task { @MainActor [weak self] in await self?.drain() }
    }
    func noteResponseTimeout() {
        needsRetry = true
        message = "알림 처리를 아직 확인하지 못했어요. 앱을 열어 예약 상태를 다시 확인해주세요."
    }
    func waitForReconciliation(until deadline: ContinuousClock.Instant) async {
        let clock = ContinuousClock()
        while reconciling && clock.now < deadline {
            try? await Task.sleep(for: .milliseconds(20))
        }
        if reconciling { needsRetry = true; message = "알림 예약 확인이 늦어지고 있어요. 앱을 열면 다시 확인해요." }
    }
    private func drain() async {
        defer { reconciling = false }
        while true {
            let seen = generation
            do {
                let system = await client.snapshot()
                guard seen == generation else { continue }
                authorization = system.authorization
                let instant = now()
                let foreign = system.pending.filter { !$0.id.hasPrefix(NotificationPlan.prefix) }.count
                var next = state
                let currentSources = try sources()
                next.tickets = NotificationPlan.make(sources: currentSources, state: state, now: instant,
                                                    timeZone: timeZone(), foreignPending: foreign)
                try install(next)
                let today = LocalDate(instant, timeZone: timeZone())
                waitingForTime = state.preferences.executionEnabled && state.preferences.executionMinutes == nil
                    ? currentSources.filter { $0.occurrence.canReplan && $0.occurrence.time == nil && $0.occurrence.day >= today }.count : 0
                waitingForCapacity = NotificationPlan.waitingCount(sources: currentSources, state: state, now: instant, timeZone: timeZone())
                let wanted = state.tickets.filter { !$0.consumed && ($0.isPlanning || $0.dueAt > instant) }
                let desired = system.allowsScheduling ? Array(wanted.prefix(max(0, NotificationPlan.budget - foreign))) : []
                let capacityLimited = system.allowsScheduling && desired.count < wanted.count
                waitingForCapacity += max(0, wanted.count - desired.count)
                let live = state.tickets.filter { !$0.consumed }
                let stalePending = system.pending.filter { item in
                    item.id.hasPrefix(NotificationPlan.prefix) && !desired.contains { $0.id == item.id && $0.generation == item.generation }
                }.map(\.id)
                let staleDelivered = system.delivered.filter { item in
                    item.id.hasPrefix(NotificationPlan.prefix) && !live.contains { $0.id == item.id && $0.generation == item.generation }
                }.map(\.id)
                if !stalePending.isEmpty { client.removePending(stalePending) }
                if !staleDelivered.isEmpty { client.removeDelivered(staleDelivered) }
                // A removal call is not a barrier. Count the actually observed occupied slots.
                let afterRemoval = await client.snapshot()
                if generation != seen { continue }
                var occupied = Set(afterRemoval.pending.map(\.id))
                var failed = false
                for ticket in desired {
                    guard generation == seen else { break }
                    // A stored DB command can finish before its observer task gets its turn.
                    guard try ticket.isPlanning || validTargets(ticket).count == ticket.targets.count else {
                        generation += 1; break
                    }
                    if afterRemoval.pending.contains(where: { $0.id == ticket.id && $0.generation == ticket.generation }) { continue }
                    guard occupied.contains(ticket.id) || occupied.count < NotificationPlan.budget else { failed = true; continue }
                    do { try await client.add(ticket); occupied.insert(ticket.id) } catch { failed = true }
                }
                if generation != seen { continue }
                let observed = await client.snapshot() // Removal is asynchronous; this is observation, not a barrier.
                if generation != seen { continue }
                let actual = Set(observed.pending.filter { $0.id.hasPrefix(NotificationPlan.prefix) }.map { "\($0.id):\($0.generation?.uuidString ?? "")" })
                let expected = Set(desired.map { "\($0.id):\($0.generation)" })
                let deliveredStillStale = observed.delivered.contains { staleDelivered.contains($0.id) }
                scheduledCount = actual.count
                needsRetry = capacityLimited || failed || actual != expected || deliveredStillStale
                if needsRetry { message = "계획은 저장됐지만 일부 알림을 반영하지 못했어요. 다시 시도할 수 있어요." }
                else { message = nil }
            } catch { needsRetry = true; message = error.localizedDescription }
            if generation == seen { break }
        }
    }
    private func install(_ next: NotificationPersistentState) throws {
        guard next != state else { return }
        try store.save(next)
        state = next
    }
    private func sources() throws -> [ExecutionSnapshot] {
        guard let container else { throw NotificationFailure.state }
        let context = ModelContext(container)
        return try context.fetch(FetchDescriptor<PlannedOccurrence>()).map { try ExecutionWriter.snapshot($0.id, in: context) }
    }
    private func validTargets(_ ticket: NotificationTicket) throws -> [ExecutionSnapshot] {
        guard let recorder else { throw NotificationFailure.state }
        return try ticket.targets.compactMap { target in
            let source = try recorder.read(target.id)
            return target.matches(source) ? source : nil
        }
    }
    func setPresentationBlocked(owner: String, blocked: Bool) {
        if blocked { blockers.insert(owner) } else { blockers.remove(owner) }
        // Ending an editor never automatically opens an external request.
    }
    func accept(_ response: NotificationEnvelope) {
        if response.action == .snooze { acceptSnooze(response); return }
        guard !responses.contains(response) else { return }
        if route?.ticket.generation == response.generation { return }
        guard responses.count < 8 else { message = "열기를 기다리는 알림을 먼저 확인해주세요."; return }
        responses.append(response)
        if !loaded || !blockers.isEmpty || route != nil { deferred = true }
        else { openPending() }
    }
    func openPending() {
        guard loaded, blockers.isEmpty, route == nil, !responses.isEmpty else { return }
        let response = responses.removeFirst()
        deferred = !responses.isEmpty
        do {
            guard let ticket = state.tickets.first(where: { $0.id == response.requestID && $0.generation == response.generation }),
                  !ticket.consumed, (!ticket.accepted || response.action == .open),
                  ticket.isPlanning ? state.preferences.planningEnabled : state.preferences.executionEnabled else { throw NotificationFailure.changed }
            if !ticket.isPlanning { guard !(try validTargets(ticket)).isEmpty else { throw NotificationFailure.changed } }
            route = NotificationRoute(id: UUID(), ticket: ticket, action: response.action)
        } catch { message = error.localizedDescription }
    }
    func dismissRoute() { route = nil; deferred = !responses.isEmpty }
    func targets(for route: NotificationRoute) throws -> [ExecutionSnapshot] { try validTargets(route.ticket) }
    /// The original notification versions stay fixed through group choice / running confirmation.
    func start(_ id: UUID, from route: NotificationRoute, replacing: ExecutionSnapshot? = nil) throws {
        guard self.route?.id == route.id, state.preferences.executionEnabled, let recorder,
              let expected = route.ticket.targets.first(where: { $0.id == id }) else { throw NotificationFailure.changed }
        let source = try recorder.read(id)
        guard expected.matches(source) else { throw NotificationFailure.changed }
        try mark(route.ticket, accepted: true, consumed: false)
        do {
            if let startCommand { try startCommand(source, replacing) }
            else { try recorder.start(source, replacing: replacing) }
        }
        catch {
            // Receipt acceptance never means app-save success. Existing OS intent stays intact.
            do { try mark(route.ticket, accepted: false, consumed: false) }
            catch { needsRetry = true; message = NotificationFailure.state.localizedDescription }
            throw error
        }
        do { try mark(route.ticket, accepted: true, consumed: true) }
        catch { needsRetry = true; message = NotificationFailure.state.localizedDescription }
        dismissRoute()
        requestReconcile()
    }
    private func mark(_ ticket: NotificationTicket, accepted: Bool, consumed: Bool) throws {
        guard let index = state.tickets.firstIndex(where: { $0.id == ticket.id && $0.generation == ticket.generation }) else { throw NotificationFailure.changed }
        var next = state; next.tickets[index].accepted = accepted; next.tickets[index].consumed = consumed
        try install(next)
    }
    func setPlanningVisible(_ visible: Bool) { planningVisible = visible }
    func setVisibleTargets(owner: String, ids: Set<UUID>) { visibleTargets[owner] = ids }
    func shouldPresent(_ response: NotificationEnvelope) -> Bool {
        guard loaded, let ticket = state.tickets.first(where: { $0.id == response.requestID && $0.generation == response.generation }),
              !ticket.consumed else { return false }
        if ticket.isPlanning { return state.preferences.planningEnabled && !planningVisible }
        guard state.preferences.executionEnabled, let valid = try? validTargets(ticket), !valid.isEmpty else { return false }
        let visible = visibleTargets.values.reduce(into: Set<UUID>()) { $0.formUnion($1) }
        return !valid.allSatisfy { visible.contains($0.id) }
    }
    /// Background snooze never changes routes or waits for a presentation/user decision.
    func acceptSnooze(_ response: NotificationEnvelope) {
        do {
            guard loaded, response.action == .snooze, state.preferences.executionEnabled,
                  let ticket = state.tickets.first(where: { $0.id == response.requestID && $0.generation == response.generation }),
                  !ticket.consumed, !ticket.accepted else { throw NotificationFailure.changed }
            let occupied = state.tickets.filter { $0.kind == .snooze && !$0.consumed && $0.dueAt > now() && $0.id != ticket.id }.count
            // Bound durable intent bookkeeping, independently of the OS's transient capacity.
            // The drain prioritizes accepted snoozes and reports any unscheduled intent as waiting.
            guard occupied < NotificationPlan.budget else { throw NotificationFailure.capacity }
            try snooze(ticket)
        } catch { message = error.localizedDescription; needsRetry = true }
    }
    private func snooze(_ ticket: NotificationTicket) throws {
        guard !ticket.isPlanning else { throw NotificationFailure.changed }
        let targets = try validTargets(ticket).map(NotificationTarget.init)
        guard !targets.isEmpty else { throw NotificationFailure.changed }
        let instant = now()
        var next = state
        guard let index = next.tickets.firstIndex(where: { $0.id == ticket.id && $0.generation == ticket.generation && !$0.consumed }) else { throw NotificationFailure.changed }
        next.tickets[index].accepted = true; next.tickets[index].consumed = true
        let snoozeID = NotificationPlan.prefix + "snooze." + ticket.generation.uuidString
        next.tickets.append(NotificationTicket(id: snoozeID, generation: UUID(), kind: .snooze, targets: targets,
            dueAt: instant.addingTimeInterval(1800), weekday: nil, minutes: nil, timeZoneID: timeZone().identifier, explanation: nil))
        try install(next)
        message = "30분 뒤에 다시 알려드릴게요. 원래 계획 날짜는 그대로예요."
        requestReconcile()
    }
}
