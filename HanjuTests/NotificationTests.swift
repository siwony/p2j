import Foundation
import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class NotificationTests: XCTestCase {
    private let day = LocalDate(year: 2026, month: 10, day: 25)!
    private enum Failure: Error { case disk, os }
    @MainActor final class Client: NotificationClient {
        var authorization: NotificationSystemSnapshot.Authorization = .authorized
        var pending: [NotificationSystemSnapshot.Request] = []
        var delivered: [NotificationSystemSnapshot.Request] = []
        var adds = 0; var removes = 0; var prompts = 0; var reads = 0
        var failAdd = false
        var beforeSnapshot: (() async -> Void)?
        var beforeAdd: (() async -> Void)?
        func snapshot() async -> NotificationSystemSnapshot {
            reads += 1
            if let beforeSnapshot { self.beforeSnapshot = nil; await beforeSnapshot() }
            return .init(authorization: authorization, pending: pending, delivered: delivered)
        }
        func authorize() async throws { prompts += 1 }
        func add(_ ticket: NotificationTicket) async throws {
            adds += 1
            if let beforeAdd { self.beforeAdd = nil; await beforeAdd() }
            if failAdd { throw Failure.os }
            pending.removeAll { $0.id == ticket.id }
            pending.append(.init(id: ticket.id, generation: ticket.generation))
        }
        func removePending(_ ids: [String]) { removes += ids.count; pending.removeAll { ids.contains($0.id) } }
        func removeDelivered(_ ids: [String]) { delivered.removeAll { ids.contains($0.id) } }
    }
    private func store() -> NotificationStateStore {
        NotificationStateStore(url: FileManager.default.temporaryDirectory.appending(path: UUID().uuidString).appending(path: "notifications.json"))
    }
    private func fixture(count: Int = 1, timed: Bool = true) throws -> (ModelContainer, [ExecutionSnapshot]) {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let routine = RoutineTemplate(name: "알림 원본")
        container.mainContext.insert(routine); try container.mainContext.save()
        let entries = (0..<count).map { _ in PlanDraft.Entry(routineID: routine.id, name: "그때 이름", expectedMinutes: nil,
            firstAction: nil, day: day, time: timed ? LocalTime(hour: 23, minute: 50) : nil) }
        try PlanWriter.confirm(PlanDraft(week: day.monday, entries: entries), in: container.mainContext)
        return (container, try entries.map { try ExecutionWriter.snapshot($0.id, in: container.mainContext) })
    }
    private var instant: Date { LocalTime(hour: 22, minute: 0)!.resolve(on: day, in: .gmt)!.instant }
    private func preferences() -> NotificationPreferences {
        var p = NotificationPreferences(); p.executionEnabled = true; p.executionMinutes = 23 * 60 + 50; return p
    }
    private func idle(_ coordinator: NotificationCoordinator) async {
        await coordinator.waitForReconciliation(until: ContinuousClock.now.advanced(by: .seconds(2)))
        XCTAssertFalse(coordinator.reconciling)
    }
    func testAtomicFilePreservesBytesOnFailureAndRejectsCorruption() throws {
        let disk = store(); var state = NotificationPersistentState(); state.preferences = preferences()
        try disk.save(state)
        let bytes = try Data(contentsOf: disk.url)
        var failed = disk; failed.write = { _, _ in throw Failure.disk }
        state.preferences.executionEnabled = false
        XCTAssertThrowsError(try failed.save(state))
        XCTAssertEqual(try Data(contentsOf: disk.url), bytes)
        XCTAssertTrue(try disk.load().preferences.executionEnabled)
        try Data("bad".utf8).write(to: disk.url)
        XCTAssertThrowsError(try disk.load())
        XCTAssertEqual(try String(contentsOf: disk.url, encoding: .utf8), "bad")
        var unknown = NotificationPersistentState(); unknown.formatVersion = 2
        try JSONEncoder().encode(unknown).write(to: disk.url)
        XCTAssertThrowsError(try disk.load())
    }
    func testPlanGroupsUntimedAndUsesFutureBudgetWithoutExpandingSnooze() throws {
        let (_, sources) = try fixture(count: 70, timed: false)
        var state = NotificationPersistentState(); state.preferences = preferences()
        var result = NotificationPlan.make(sources: sources, state: state, now: instant, timeZone: .gmt, foreignPending: 0)
        XCTAssertEqual(result.count, 1); XCTAssertEqual(result[0].targets.count, 70); XCTAssertEqual(result[0].kind, .group)
        state.preferences.executionMinutes = nil
        XCTAssertTrue(NotificationPlan.make(sources: sources, state: state, now: instant, timeZone: .gmt, foreignPending: 0).isEmpty)
        let (timedContainer, timed) = try fixture(count: 70)
        state.preferences = preferences()
        result = NotificationPlan.make(sources: timed, state: state, now: instant, timeZone: .gmt, foreignPending: 3)
        XCTAssertEqual(result.count, 53) // 64 minus 3 foreign minus 8 snooze reserve.
        XCTAssertTrue(result.allSatisfy { $0.dueAt > instant })
        let nearer = timed.last!
        try PlanWriter.move(nearer.occurrence, to: day, time: LocalTime(hour: 22, minute: 30), in: timedContainer.mainContext)
        let updated = try timed.map { try ExecutionWriter.snapshot($0.id, in: ModelContext(timedContainer)) }
        let prioritized = NotificationPlan.make(sources: updated, state: state, now: instant, timeZone: .gmt, foreignPending: 3)
        XCTAssertEqual(prioritized.first?.targets.first?.id, nearer.id, "Nearer future work must precede later normal requests")
    }
    func testDSTAndTimeZoneReconcileUsesCivilPlanAndResolvedInstant() throws {
        let zone = TimeZone(identifier: "America/New_York")!
        let spring = LocalDate(year: 2026, month: 3, day: 8)!
        let result = LocalTime(hour: 2, minute: 30)!.resolve(on: spring, in: zone)!
        XCTAssertNotNil(result.explanation)
        XCTAssertEqual(LocalDate.calendar(in: zone).component(.hour, from: result.instant), 3)
        let autumn = LocalTime(hour: 1, minute: 30)!.resolve(on: LocalDate(year: 2026, month: 11, day: 1)!, in: zone)!
        XCTAssertNotNil(autumn.explanation)
        let (_, sources) = try fixture()
        var state = NotificationPersistentState(); state.preferences = preferences()
        let original = NotificationPlan.make(sources: sources, state: state, now: instant.addingTimeInterval(-86400), timeZone: .gmt, foreignPending: 0)
        state.tickets = original
        let changed = NotificationPlan.make(sources: sources, state: state, now: instant.addingTimeInterval(-86400), timeZone: zone, foreignPending: 0)
        XCTAssertEqual(changed[0].targets[0].dayKey, original[0].targets[0].dayKey)
        XCTAssertNotEqual(changed[0].dueAt, original[0].dueAt); XCTAssertNotEqual(changed[0].generation, original[0].generation)
    }
    func testNoLaunchPromptIndependentTogglesAndPersistenceFailureCallsNoOS() async throws {
        let (container, _) = try fixture(); let client = Client(); let disk = store()
        let coordinator = NotificationCoordinator(store: disk, client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        XCTAssertEqual(client.prompts, 0); XCTAssertEqual(client.adds, 0)
        await coordinator.updatePreferences(preferences(), requestPermission: true); await idle(coordinator)
        XCTAssertEqual(client.prompts, 1); XCTAssertEqual(client.pending.count, 1)
        var p = preferences(); p.planningEnabled = true
        await coordinator.updatePreferences(p); await idle(coordinator)
        p.executionEnabled = false
        await coordinator.updatePreferences(p); await idle(coordinator)
        XCTAssertEqual(client.pending.map(\.id), ["hanju.planning"])
        var failedDisk = store(); failedDisk.write = { _, _ in throw Failure.disk }
        let failedClient = Client()
        let failed = NotificationCoordinator(store: failedDisk, client: failedClient, now: { self.instant })
        failed.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(failed)
        let reads = failedClient.reads
        await failed.updatePreferences(preferences(), requestPermission: true)
        XCTAssertEqual(failedClient.reads, reads); XCTAssertEqual(failedClient.prompts, 0); XCTAssertEqual(failedClient.adds, 0)
        XCTAssertFalse(failed.state.preferences.executionEnabled)
    }
    func testSnoozeCrossesSundayMidnightFixedOnRetryAndDuplicateRejectedAfterReopen() async throws {
        let (container, sources) = try fixture(count: 2, timed: false); let disk = store(); let client = Client()
        var now = instant
        let coordinator = NotificationCoordinator(store: disk, client: client, now: { now }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let original = try XCTUnwrap(coordinator.state.tickets.first)
        now = original.dueAt
        let response = NotificationEnvelope(requestID: original.id, generation: original.generation, action: .snooze)
        coordinator.acceptSnooze(response); await idle(coordinator)
        let snooze = try XCTUnwrap(coordinator.state.tickets.first(where: { $0.kind == .snooze }))
        XCTAssertEqual(LocalDate(snooze.dueAt, timeZone: .gmt), day.adding(days: 1))
        XCTAssertEqual(snooze.targets.map(\.id), original.targets.map(\.id))
        XCTAssertTrue(snooze.targets.allSatisfy { $0.dayKey == day.key })
        now = now.addingTimeInterval(60); client.failAdd = true; client.pending = []
        coordinator.retry(); await idle(coordinator)
        XCTAssertEqual(coordinator.state.tickets.first(where: { $0.kind == .snooze })?.dueAt, snooze.dueAt)
        coordinator.acceptSnooze(response); await idle(coordinator)
        XCTAssertEqual(coordinator.state.tickets.filter { $0.kind == .snooze }.count, 1)
        let reopened = NotificationCoordinator(store: disk, client: Client(), now: { now }, timeZone: { .gmt })
        reopened.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(reopened)
        reopened.acceptSnooze(response); await idle(reopened)
        XCTAssertEqual(reopened.state.tickets.filter { $0.kind == .snooze }.count, 1)
        reopened.accept(.init(requestID: snooze.id, generation: snooze.generation, action: .open))
        XCTAssertEqual(try reopened.targets(for: XCTUnwrap(reopened.route)).map(\.id), sources.map(\.id).sorted { $0.uuidString < $1.uuidString })
    }
    func testSaveFailureRetainsOriginalPendingAndReceiptDoesNotConsumeSchedule() async throws {
        let (container, sources) = try fixture(); let client = Client(); var saveCalled = false
        let coordinator = NotificationCoordinator(store: store(), client: client, startCommand: { source, replacing in
            try ExecutionWriter.start(source, replacing: replacing, at: ExecutionClock.now(), in: container.mainContext,
                save: { _ in saveCalled = true; throw Failure.disk })
        }, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let ticket = try XCTUnwrap(coordinator.state.tickets.first)
        let pending = client.pending
        coordinator.accept(.init(requestID: ticket.id, generation: ticket.generation, action: .start))
        let route = try XCTUnwrap(coordinator.route)
        XCTAssertThrowsError(try coordinator.start(sources[0].id, from: route)) { error in
            guard case Failure.disk = error else { return XCTFail("Wrong error: \(error)") }
        }
        XCTAssertTrue(saveCalled)
        coordinator.requestReconcile(); await idle(coordinator)
        XCTAssertEqual(client.pending, pending); XCTAssertFalse(coordinator.state.tickets[0].consumed)
        XCTAssertFalse(coordinator.state.tickets[0].accepted)
        XCTAssertEqual(try ExecutionWriter.snapshot(sources[0].id, in: container.mainContext).occurrence.status, .planned)
    }
    func testDeferredResponsePreservesPresentationAndGroupChoiceVersions() async throws {
        let (container, sources) = try fixture(count: 2, timed: false); let client = Client()
        let recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: store(), client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let ticket = try XCTUnwrap(coordinator.state.tickets.first)
        coordinator.setPresentationBlocked(owner: "editor", blocked: true)
        coordinator.accept(.init(requestID: ticket.id, generation: ticket.generation, action: .start))
        XCTAssertNil(coordinator.route); XCTAssertTrue(coordinator.deferred); XCTAssertNil(recorder.active)
        coordinator.setPresentationBlocked(owner: "editor", blocked: false)
        XCTAssertNil(coordinator.route) // Dismissal alone never routes.
        coordinator.openPending(); let route = try XCTUnwrap(coordinator.route)
        XCTAssertEqual(try coordinator.targets(for: route).count, 2); XCTAssertNil(recorder.active)
        try coordinator.start(sources[0].id, from: route); await idle(coordinator)
        XCTAssertEqual(recorder.active?.id, sources[0].id)
        coordinator.accept(.init(requestID: ticket.id, generation: ticket.generation, action: .start))
        XCTAssertNil(coordinator.route)
        XCTAssertEqual(try recorder.read(sources[1].id).occurrence.status, .planned)
    }
    func testOpenedGroupStartsUnchangedOriginalTargetAfterReconciliation() async throws {
        let (container, sources) = try fixture(count: 2, timed: false)
        let recorder = ExecutionRecorder(container: container), client = Client()
        let coordinator = NotificationCoordinator(store: store(), client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let original = try XCTUnwrap(coordinator.state.tickets.first { $0.kind == .group })
        coordinator.accept(.init(requestID: original.id, generation: original.generation, action: .open))
        let route = try XCTUnwrap(coordinator.route)
        try recorder.complete(sources[0])
        coordinator.requestReconcile(); await idle(coordinator)
        let replacement = try XCTUnwrap(coordinator.state.tickets.first { $0.id == original.id })
        XCTAssertNotEqual(replacement.generation, original.generation)
        XCTAssertEqual(try coordinator.targets(for: route).map(\.id), [sources[1].id])
        XCTAssertEqual(try recorder.read(sources[1].id), sources[1])
        try coordinator.start(sources[1].id, from: route)
        XCTAssertEqual(recorder.active?.id, sources[1].id)
        XCTAssertNil(coordinator.route)
    }
    func testRetiredGroupKeepsOriginalTargetsAcrossCompletionMoveSkipAndSnoozeMonday() async throws {
        for snoozed in [false, true] {
            for change in ["complete", "move", "skip"] {
                let (container, sources) = try fixture(count: 2, timed: false)
                let disk = store(), client = Client(), recorder = ExecutionRecorder(container: container)
                var now = instant
                let coordinator = NotificationCoordinator(store: disk, client: client, now: { now }, timeZone: { .gmt })
                coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
                await coordinator.updatePreferences(preferences()); await idle(coordinator)
                var original = try XCTUnwrap(coordinator.state.tickets.first { $0.kind == .group })
                if snoozed {
                    now = original.dueAt
                    coordinator.acceptSnooze(.init(requestID: original.id, generation: original.generation, action: .snooze))
                    await idle(coordinator)
                    original = try XCTUnwrap(coordinator.state.tickets.first { $0.kind == .snooze })
                    now = original.dueAt // Sunday's group is opened on Monday, still with Sunday's IDs/day.
                    XCTAssertEqual(LocalDate(now, timeZone: .gmt), day.adding(days: 1))
                }
                let envelope = NotificationEnvelope(requestID: original.id, generation: original.generation, action: .open)
                coordinator.accept(envelope)
                let route = try XCTUnwrap(coordinator.route)
                switch change {
                case "complete": try recorder.complete(sources[0])
                case "move": try PlanWriter.move(sources[0].occurrence, to: day.adding(days: 1), time: nil, in: container.mainContext)
                default: try PlanWriter.skip(sources[0].occurrence, in: container.mainContext)
                }
                let newEntry = PlanDraft.Entry(routineID: sources[0].occurrence.routineID, name: "새 C", expectedMinutes: nil,
                                               firstAction: nil, day: day)
                try PlanWriter.confirm(PlanDraft(week: day.monday, entries: [newEntry]), in: container.mainContext)
                coordinator.requestReconcile(); await idle(coordinator)
                let replacement = try XCTUnwrap(coordinator.state.tickets.first { $0.id == original.id })
                XCTAssertNotEqual(replacement.generation, original.generation)
                XCTAssertEqual(try coordinator.targets(for: route).map(\.id), [sources[1].id])
                XCTAssertEqual(route.ticket, original)
                XCTAssertTrue(route.ticket.targets.allSatisfy { $0.dayKey == day.key })
                XCTAssertThrowsError(try coordinator.start(sources[0].id, from: route))
                XCTAssertThrowsError(try coordinator.start(newEntry.id, from: route))
                let forged = NotificationRoute(id: route.id, ticket: replacement, action: route.action)
                XCTAssertThrowsError(try coordinator.start(sources[1].id, from: forged), "A route UUID cannot authorize a replacement ticket")
                let persisted = try disk.load()
                XCTAssertFalse(persisted.tickets.contains { $0.generation == original.generation })
                let reopened = NotificationCoordinator(store: disk, client: Client(), now: { now }, timeZone: { .gmt })
                reopened.attach(container: container, recorder: recorder); await idle(reopened)
                reopened.accept(envelope)
                XCTAssertNil(reopened.route); XCTAssertNil(recorder.active)
                try coordinator.start(sources[1].id, from: route)
                // No suspension yet: starting from the old route must not mark the replacement B+C receipt.
                XCTAssertEqual(coordinator.state.tickets.first { $0.id == replacement.id }, replacement)
                XCTAssertEqual(try disk.load().tickets.first { $0.id == replacement.id }, replacement)
                XCTAssertEqual(recorder.active?.id, sources[1].id)
                XCTAssertEqual(recorder.active?.occurrence.day, day)
                let started = try recorder.read(sources[1].id)
                XCTAssertEqual(started.intervals.count, 1)
                XCTAssertThrowsError(try coordinator.start(sources[1].id, from: route))
                XCTAssertEqual(try recorder.read(sources[1].id), started)
                await idle(coordinator)
                XCTAssertEqual(try recorder.read(newEntry.id).occurrence.status, .planned)
                if !snoozed {
                    let remaining = try XCTUnwrap(coordinator.state.tickets.first { $0.id == original.id })
                    XCTAssertEqual(remaining.targets.map(\.id), [newEntry.id])
                    XCTAssertFalse(remaining.accepted); XCTAssertFalse(remaining.consumed)
                    XCTAssertTrue(client.pending.contains { $0.id == remaining.id && $0.generation == remaining.generation })
                }
            }
        }
    }
    func testRetiredRouteRejectsChangedTargetAndKeepsRunningOnUnconfirmedSwitch() async throws {
        let (container, sources) = try fixture(count: 3, timed: false)
        let recorder = ExecutionRecorder(container: container), client = Client()
        let coordinator = NotificationCoordinator(store: store(), client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let original = try XCTUnwrap(coordinator.state.tickets.first)
        coordinator.accept(.init(requestID: original.id, generation: original.generation, action: .open))
        let route = try XCTUnwrap(coordinator.route)
        try recorder.complete(sources[0]); try recorder.start(sources[2])
        coordinator.requestReconcile(); await idle(coordinator)
        let running = try XCTUnwrap(recorder.active), pending = client.pending
        XCTAssertThrowsError(try coordinator.start(sources[1].id, from: route)) { error in
            guard case ExecutionError.anotherRunning = error else { return XCTFail("Wrong error: \(error)") }
        }
        XCTAssertEqual(recorder.active, running); XCTAssertEqual(client.pending, pending)
        XCTAssertEqual(try recorder.read(sources[1].id), sources[1])
        // A cancelled confirmation makes no command; keep this original route for a later explicit choice.
        XCTAssertEqual(coordinator.route, route)
        try PlanWriter.move(sources[1].occurrence, to: day, time: LocalTime(hour: 23, minute: 59), in: container.mainContext)
        coordinator.requestReconcile(); await idle(coordinator)
        XCTAssertTrue(try coordinator.targets(for: route).isEmpty)
        XCTAssertThrowsError(try coordinator.start(sources[1].id, from: route, replacing: running)) { error in
            guard case NotificationFailure.changed = error else { return XCTFail("Wrong error: \(error)") }
        }
        XCTAssertEqual(recorder.active, running)
    }
    func testRetiredRouteSaveFailurePreservesNewScheduleAndExplicitRetry() async throws {
        let (container, sources) = try fixture(count: 2, timed: false)
        let recorder = ExecutionRecorder(container: container), client = Client(), disk = store()
        var fail = true, saveCalls = 0
        let coordinator = NotificationCoordinator(store: disk, client: client, startCommand: { source, replacing in
            try ExecutionWriter.start(source, replacing: replacing, at: ExecutionClock.now(), in: container.mainContext,
                save: { context in saveCalls += 1; if fail { throw Failure.disk }; try context.save() })
            recorder.refresh()
        }, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let original = try XCTUnwrap(coordinator.state.tickets.first)
        coordinator.accept(.init(requestID: original.id, generation: original.generation, action: .open))
        let route = try XCTUnwrap(coordinator.route)
        try recorder.complete(sources[0]); coordinator.requestReconcile(); await idle(coordinator)
        let bytes = try Data(contentsOf: disk.url), pending = client.pending
        let adds = client.adds, removes = client.removes
        XCTAssertThrowsError(try coordinator.start(sources[1].id, from: route)) { error in
            guard case Failure.disk = error else { return XCTFail("Wrong error: \(error)") }
        }
        XCTAssertEqual(saveCalls, 1); XCTAssertEqual(coordinator.route, route)
        XCTAssertEqual(try recorder.read(sources[1].id), sources[1]); XCTAssertNil(recorder.active)
        XCTAssertEqual(try Data(contentsOf: disk.url), bytes)
        coordinator.requestReconcile(); await idle(coordinator)
        XCTAssertEqual(client.pending, pending); XCTAssertEqual(client.adds, adds); XCTAssertEqual(client.removes, removes)
        fail = false
        try coordinator.start(sources[1].id, from: route)
        XCTAssertEqual(saveCalls, 2); XCTAssertEqual(recorder.active?.id, sources[1].id)
        XCTAssertEqual(try recorder.read(sources[1].id).intervals.count, 1)
        await idle(coordinator)
    }
    func testLiveGenerationReceiptWriteFailurePreventsExecution() async throws {
        let (container, sources) = try fixture(count: 2, timed: false)
        var disk = store(), failWrite = false, writes = 0, starts = 0
        disk.write = { data, url in
            writes += 1
            if failWrite { throw Failure.disk }
            try data.write(to: url, options: .atomic)
        }
        let client = Client(), recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: disk, client: client, startCommand: { _, _ in starts += 1 },
                                                   now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let original = try XCTUnwrap(coordinator.state.tickets.first)
        coordinator.accept(.init(requestID: original.id, generation: original.generation, action: .open))
        let route = try XCTUnwrap(coordinator.route)
        let bytes = try Data(contentsOf: disk.url), state = coordinator.state, pending = client.pending, beforeWrites = writes
        failWrite = true
        XCTAssertThrowsError(try coordinator.start(sources[1].id, from: route)) { error in
            guard case Failure.disk = error else { return XCTFail("Wrong error: \(error)") }
        }
        XCTAssertEqual(writes, beforeWrites + 1); XCTAssertEqual(starts, 0)
        XCTAssertEqual(coordinator.state, state); XCTAssertEqual(try Data(contentsOf: disk.url), bytes)
        XCTAssertEqual(client.pending, pending); XCTAssertEqual(try recorder.read(sources[1].id), sources[1])
    }
    func testChangeDuringOSAddDrainsAndRemovesObsoleteRequest() async throws {
        let (container, sources) = try fixture(); let client = Client()
        let coordinator = NotificationCoordinator(store: store(), client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        client.beforeAdd = {
            try? PlanWriter.skip(sources[0].occurrence, in: container.mainContext)
            await Task.yield()
        }
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        XCTAssertTrue(client.pending.isEmpty)
        XCTAssertEqual(try ExecutionWriter.snapshot(sources[0].id, in: container.mainContext).occurrence.status, .skipped)
        XCTAssertFalse(coordinator.needsRetry)
    }
    func testForegroundSuppressionUsesGenerationDBAndActuallyVisibleTargets() async throws {
        let (container, sources) = try fixture(); let client = Client()
        let coordinator = NotificationCoordinator(store: store(), client: client, now: { self.instant }, timeZone: { .gmt })
        let recorder = ExecutionRecorder(container: container)
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let ticket = try XCTUnwrap(coordinator.state.tickets.first)
        let envelope = NotificationEnvelope(requestID: ticket.id, generation: ticket.generation, action: .open)
        XCTAssertTrue(coordinator.shouldPresent(envelope))
        coordinator.setVisibleTargets(owner: "today", ids: [sources[0].id]); XCTAssertFalse(coordinator.shouldPresent(envelope))
        coordinator.setVisibleTargets(owner: "today", ids: [])
        try recorder.complete(sources[0]); XCTAssertFalse(coordinator.shouldPresent(envelope))
        XCTAssertFalse(coordinator.shouldPresent(.init(requestID: ticket.id, generation: UUID(), action: .open)))
    }
    func testRestRollbackThenRestoreAndReplanReconcileOnlyCommittedTargets() async throws {
        let (container, initial) = try fixture(count: 3)
        let context = container.mainContext
        // One original normal, one grouped untimed and one snoozed request.
        try PlanWriter.move(initial[1].occurrence, to: day, time: nil, in: context)
        var now = instant
        let disk = store(), client = Client(), recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: disk, client: client, now: { now }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        var prefs = preferences(); prefs.planningEnabled = true
        await coordinator.updatePreferences(prefs); await idle(coordinator)
        let ticket = try XCTUnwrap(coordinator.state.tickets.first { $0.targets.first?.id == initial[2].id })
        coordinator.acceptSnooze(.init(requestID: ticket.id, generation: ticket.generation, action: .snooze)); await idle(coordinator)
        XCTAssertTrue(coordinator.state.tickets.contains { $0.kind == .snooze })
        XCTAssertTrue(coordinator.state.tickets.contains { $0.kind == .group })
        let before = client.pending, beforeState = coordinator.state
        let original = try initial.map { try recorder.read($0.id) }
        var saveCalled = false
        XCTAssertThrowsError(try PlanWriter.rest(original.map(\.occurrence), today: day, in: context, save: { _ in
            saveCalled = true; throw Failure.disk
        })) { error in guard case Failure.disk = error else { return XCTFail("Wrong failure: \(error)") } }
        XCTAssertTrue(saveCalled)
        coordinator.requestReconcile(); await idle(coordinator)
        XCTAssertEqual(client.pending, before); XCTAssertEqual(coordinator.state, beforeState)
        XCTAssertEqual(try initial.map { try recorder.read($0.id) }, original)
        try PlanWriter.rest(original.map(\.occurrence), today: day, in: context)
        let deadline = ContinuousClock.now.advanced(by: .seconds(2))
        while client.pending.map(\.id) != ["hanju.planning"] && ContinuousClock.now < deadline { await Task.yield() }
        XCTAssertEqual(client.pending.map(\.id), ["hanju.planning"]) // Product didSave observer, no test signal.
        await idle(coordinator)
        XCTAssertFalse(coordinator.state.tickets.contains { $0.kind == .snooze })
        let skipped = try recorder.read(initial[0].id)
        try PlanWriter.move(skipped.occurrence, to: day, time: LocalTime(hour: 23, minute: 55),
                            restore: true, in: context)
        coordinator.requestReconcile(); await idle(coordinator)
        XCTAssertTrue(client.pending.contains { $0.id == "hanju.single.\(skipped.id)" })
        let restored = try recorder.read(skipped.id)
        XCTAssertEqual(restored.occurrence.id, skipped.id)
        XCTAssertEqual(restored.occurrence.name, original[0].occurrence.name)
        XCTAssertEqual(restored.intervals, original[0].intervals)
        // Replan a separately restored Friday to Sunday, retaining its ID and snapshot.
        let past = day.adding(days: -2)
        let second = try recorder.read(initial[1].id)
        try PlanWriter.move(second.occurrence, to: past, time: nil, restore: true, in: context)
        let source = try recorder.read(second.id)
        try PlanWriter.replan([source.occurrence], to: day, today: day, in: context)
        now = instant.addingTimeInterval(60)
        coordinator.requestReconcile(); await idle(coordinator)
        XCTAssertTrue(client.pending.contains { $0.id == "hanju.group.\(day.key)" })
        XCTAssertFalse(coordinator.state.tickets.contains { $0.kind == .snooze })
        XCTAssertEqual(try recorder.read(second.id).occurrence.name, original[1].occurrence.name)
    }
    func testAcceptedReceiptReopenNeverAutomaticallyStartsOrRefreshesExpectedVersion() async throws {
        let (container, sources) = try fixture(); let disk = store()
        var state = NotificationPersistentState(); state.preferences = preferences()
        state.tickets = NotificationPlan.make(sources: sources, state: state, now: instant, timeZone: .gmt, foreignPending: 0)
        state.tickets[0].accepted = true; try disk.save(state)
        let original = state.tickets[0]
        let recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: disk, client: Client(), now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        coordinator.accept(.init(requestID: original.id, generation: original.generation, action: .start))
        XCTAssertNil(coordinator.route); XCTAssertNil(recorder.active)
        // An explicit body opening can offer a retry only against the original persisted version.
        coordinator.accept(.init(requestID: original.id, generation: original.generation, action: .open))
        let route = try XCTUnwrap(coordinator.route)
        try PlanWriter.move(sources[0].occurrence, to: day, time: LocalTime(hour: 23, minute: 59), in: container.mainContext)
        XCTAssertThrowsError(try coordinator.start(sources[0].id, from: route))
        XCTAssertNil(recorder.active)
    }
    func testCapacityAndMissingTimeAreVisibleWaitingStatesAndForeignRequestsStay() async throws {
        let (container, _) = try fixture(count: 70)
        let client = Client(); client.pending = (0..<3).map { .init(id: "foreign.\($0)", generation: nil) }
        let coordinator = NotificationCoordinator(store: store(), client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        var prefs = preferences(); prefs.planningEnabled = true
        await coordinator.updatePreferences(prefs); await idle(coordinator)
        XCTAssertEqual(client.pending.filter { $0.id.hasPrefix("foreign.") }.count, 3)
        XCTAssertEqual(coordinator.waitingForCapacity, 18) // 70 minus 52 normal slots, with planning + 8 reserved.
        XCTAssertEqual(client.pending.count, 56)
        let (untimedContainer, _) = try fixture(count: 2, timed: false)
        let untimed = NotificationCoordinator(store: store(), client: Client(), now: { self.instant }, timeZone: { .gmt })
        untimed.attach(container: untimedContainer, recorder: ExecutionRecorder(container: untimedContainer)); await idle(untimed)
        prefs.executionMinutes = nil
        await untimed.updatePreferences(prefs); await idle(untimed)
        XCTAssertEqual(untimed.waitingForTime, 2)
        let fullClient = Client(); fullClient.pending = (0..<64).map { .init(id: "foreign.\($0)", generation: nil) }
        let planningOnly = NotificationCoordinator(store: store(), client: fullClient, now: { self.instant }, timeZone: { .gmt })
        planningOnly.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(planningOnly)
        var planning = NotificationPreferences(); planning.planningEnabled = true
        await planningOnly.updatePreferences(planning); await idle(planningOnly)
        XCTAssertEqual(planningOnly.waitingForCapacity, 1)
        XCTAssertEqual(fullClient.adds, 0); XCTAssertEqual(fullClient.pending.count, 64)
    }

    func testLargeLegitimateGroupReopensAndMissingTimeWriteFailureReportsFalse() async throws {
        let (container, first) = try fixture(count: 100, timed: false)
        let routineID = first[0].occurrence.routineID
        for count in [100, 100, 100, 100, 13] {
            let entries = (0..<count).map { _ in PlanDraft.Entry(routineID: routineID, name: "큰 묶음", expectedMinutes: nil, firstAction: nil, day: day) }
            try PlanWriter.confirm(PlanDraft(week: day.monday, entries: entries), in: container.mainContext)
        }
        let sources = try container.mainContext.fetch(FetchDescriptor<PlannedOccurrence>()).map { try ExecutionWriter.snapshot($0.id, in: container.mainContext) }
        let disk = store(); var state = NotificationPersistentState(); state.preferences = preferences()
        state.tickets = NotificationPlan.make(sources: sources, state: state, now: instant, timeZone: .gmt, foreignPending: 0)
        XCTAssertEqual(state.tickets.first?.targets.count, 513)
        try disk.save(state); XCTAssertEqual(try disk.load(), state)
        var failedDisk = store(); failedDisk.write = { _, _ in throw Failure.disk }
        let coordinator = NotificationCoordinator(store: failedDisk, client: Client(), now: { self.instant })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        var draft = preferences(); draft.executionMinutes = 17 * 60 + 35
        let saved = await coordinator.updatePreferences(draft)
        XCTAssertFalse(saved); XCTAssertNil(coordinator.state.preferences.executionMinutes)
        XCTAssertEqual(draft.executionMinutes, 17 * 60 + 35)
        XCTAssertNotNil(coordinator.message)
    }

    func testNinthSnoozeUsesNormalCapacityAndSurvivesForeignCapacityLossAndReopen() async throws {
        let (container, _) = try fixture(count: 70)
        let disk = store(), client = Client()
        let coordinator = NotificationCoordinator(store: disk, client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        var prefs = preferences(); prefs.planningEnabled = true
        await coordinator.updatePreferences(prefs); await idle(coordinator)
        let normals = Array(coordinator.state.tickets.filter { $0.kind == .single }.prefix(9))
        XCTAssertEqual(normals.count, 9)
        for ticket in normals {
            coordinator.acceptSnooze(.init(requestID: ticket.id, generation: ticket.generation, action: .snooze)); await idle(coordinator)
        }
        let accepted = coordinator.state.tickets.filter { $0.kind == .snooze && !$0.consumed && $0.dueAt > self.instant }
        XCTAssertEqual(accepted.count, 9)
        XCTAssertLessThanOrEqual(client.pending.count, 64)
        XCTAssertEqual(client.pending.filter { $0.id.contains("snooze.") }.count, 9)
        let remainingNormals = coordinator.state.tickets.filter { $0.kind == .single && !$0.consumed && $0.dueAt > self.instant }
        XCTAssertLessThanOrEqual(remainingNormals.count, 54)
        client.pending += (0..<60).map { .init(id: "foreign.\($0)", generation: nil) }
        coordinator.requestReconcile(); await idle(coordinator)
        XCTAssertEqual(coordinator.state.tickets.filter { $0.kind == .snooze && !$0.consumed }, accepted)
        XCTAssertGreaterThan(coordinator.waitingForCapacity, 0)
        let reopened = NotificationCoordinator(store: disk, client: client, now: { self.instant }, timeZone: { .gmt })
        reopened.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(reopened)
        XCTAssertEqual(reopened.state.tickets.filter { $0.kind == .snooze && !$0.consumed }, accepted)
        reopened.acceptSnooze(.init(requestID: normals[0].id, generation: normals[0].generation, action: .snooze))
        XCTAssertEqual(reopened.state.tickets.filter { $0.kind == .snooze && !$0.consumed }, accepted)
    }

    func testSnoozeIntentIsDurableBeforeSuspendedOSReadAndKeepsFixedDueAt() async throws {
        let (container, _) = try fixture(); let disk = store(), client = Client()
        let coordinator = NotificationCoordinator(store: disk, client: client, now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: ExecutionRecorder(container: container)); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let original = try XCTUnwrap(coordinator.state.tickets.first)
        var release: CheckedContinuation<Void, Never>?
        client.beforeSnapshot = { await withCheckedContinuation { release = $0 } }
        coordinator.requestReconcile()
        for _ in 0..<100 where release == nil { await Task.yield() }
        XCTAssertNotNil(release)
        let reads = client.reads
        coordinator.acceptSnooze(.init(requestID: original.id, generation: original.generation, action: .snooze))
        let reopened = try disk.load()
        let snooze = try XCTUnwrap(reopened.tickets.first { $0.kind == .snooze })
        XCTAssertEqual(snooze.dueAt, instant.addingTimeInterval(1800))
        XCTAssertEqual(snooze.targets, original.targets)
        XCTAssertTrue(try XCTUnwrap(reopened.tickets.first { $0.id == original.id }).consumed)
        XCTAssertEqual(client.reads, reads, "Accepting the intent must not await/query the OS")
        XCTAssertTrue(coordinator.reconciling)
        release?.resume(); await idle(coordinator)
        XCTAssertEqual(try disk.load().tickets.first { $0.id == snooze.id }, snooze)
    }

    func testRepeatedBodyOpenCreatesNewPresentationWithoutStarting() async throws {
        let (container, sources) = try fixture()
        let recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: store(), client: Client(), now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let ticket = try XCTUnwrap(coordinator.state.tickets.first)
        let response = NotificationEnvelope(requestID: ticket.id, generation: ticket.generation, action: .open)
        coordinator.accept(response)
        let first = try XCTUnwrap(coordinator.route)
        coordinator.accept(response)
        let second = try XCTUnwrap(coordinator.route)
        XCTAssertNotEqual(first.id, second.id, "An explicit body reopening must be observable by the tab router")
        XCTAssertEqual(second.ticket, first.ticket); XCTAssertEqual(second.action, .open)
        XCTAssertNil(recorder.active); XCTAssertEqual(try recorder.read(sources[0].id), sources[0])
    }
    func testPendingOpenReplacesOldViewOnlyAfterEditorEndsAndExplicitOpen() async throws {
        let (container, sources) = try fixture(count: 2)
        let recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: store(), client: Client(), now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let firstTicket = try XCTUnwrap(coordinator.state.tickets.first { $0.targets.first?.id == sources[0].id })
        let secondTicket = try XCTUnwrap(coordinator.state.tickets.first { $0.targets.first?.id == sources[1].id })
        coordinator.accept(.init(requestID: firstTicket.id, generation: firstTicket.generation, action: .open))
        let first = try XCTUnwrap(coordinator.route)
        coordinator.setPresentationBlocked(owner: "records-memo", blocked: true)
        coordinator.accept(.init(requestID: secondTicket.id, generation: secondTicket.generation, action: .open))
        XCTAssertEqual(coordinator.route, first); XCTAssertTrue(coordinator.deferred)
        coordinator.openPending()
        XCTAssertEqual(coordinator.route, first); XCTAssertTrue(coordinator.deferred)
        coordinator.setPresentationBlocked(owner: "records-memo", blocked: false)
        XCTAssertEqual(coordinator.route, first); XCTAssertTrue(coordinator.deferred)
        coordinator.openPending()
        let second = try XCTUnwrap(coordinator.route)
        XCTAssertEqual(second.ticket, secondTicket); XCTAssertNotEqual(second.id, first.id)
        XCTAssertFalse(coordinator.deferred); XCTAssertNil(recorder.active)
    }

    func testNewBodyReplacesReadOnlyRouteButInvalidResponsePreservesIt() async throws {
        let (container, sources) = try fixture(count: 2)
        let recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: store(), client: Client(), now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let a = try XCTUnwrap(coordinator.state.tickets.first { $0.targets.first?.id == sources[0].id })
        let b = try XCTUnwrap(coordinator.state.tickets.first { $0.targets.first?.id == sources[1].id })
        coordinator.accept(.init(requestID: a.id, generation: a.generation, action: .open))
        let oldRoute = try XCTUnwrap(coordinator.route)
        coordinator.accept(.init(requestID: b.id, generation: UUID(), action: .open))
        XCTAssertEqual(coordinator.route, oldRoute); XCTAssertNotNil(coordinator.message)
        coordinator.accept(.init(requestID: b.id, generation: b.generation, action: .open))
        let newRoute = try XCTUnwrap(coordinator.route)
        XCTAssertEqual(newRoute.ticket, b); XCTAssertNotEqual(newRoute.id, oldRoute.id)
        XCTAssertFalse(coordinator.deferred); XCTAssertNil(recorder.active)
        XCTAssertThrowsError(try coordinator.start(sources[0].id, from: oldRoute))
        try PlanWriter.move(sources[0].occurrence, to: day.adding(days: 1), time: sources[0].occurrence.time, in: container.mainContext)
        coordinator.accept(.init(requestID: a.id, generation: a.generation, action: .open))
        XCTAssertEqual(coordinator.route, newRoute, "An outdated target must not replace the valid visible route")
        XCTAssertNil(recorder.active)
        await idle(coordinator)
    }
    func testBodyReopeningDoesNotReplayStartOrBypassMultiplePresentationBlockers() async throws {
        let (container, sources) = try fixture(count: 2)
        let recorder = ExecutionRecorder(container: container)
        let coordinator = NotificationCoordinator(store: store(), client: Client(), now: { self.instant }, timeZone: { .gmt })
        coordinator.attach(container: container, recorder: recorder); await idle(coordinator)
        await coordinator.updatePreferences(preferences()); await idle(coordinator)
        let a = try XCTUnwrap(coordinator.state.tickets.first { $0.targets.first?.id == sources[0].id })
        let start = NotificationEnvelope(requestID: a.id, generation: a.generation, action: .start)
        coordinator.accept(start)
        let first = try XCTUnwrap(coordinator.route)
        coordinator.accept(start)
        XCTAssertEqual(coordinator.route, first)
        try recorder.start(sources[1])
        let running = try XCTUnwrap(recorder.active)
        coordinator.setPresentationBlocked(owner: "records", blocked: true)
        coordinator.setPresentationBlocked(owner: "switch-confirmation", blocked: true)
        let open = NotificationEnvelope(requestID: a.id, generation: a.generation, action: .open)
        coordinator.accept(open); coordinator.accept(open)
        XCTAssertEqual(coordinator.route, first); XCTAssertTrue(coordinator.deferred)
        coordinator.setPresentationBlocked(owner: "records", blocked: false)
        coordinator.openPending()
        XCTAssertEqual(coordinator.route, first)
        coordinator.setPresentationBlocked(owner: "switch-confirmation", blocked: false)
        XCTAssertEqual(coordinator.route, first, "Cancelling the confirmation must not consume the pending body request")
        coordinator.openPending()
        let reopened = try XCTUnwrap(coordinator.route)
        XCTAssertNotEqual(reopened.id, first.id); XCTAssertEqual(reopened.action, .open)
        XCTAssertFalse(coordinator.deferred); XCTAssertEqual(recorder.active, running)
        coordinator.accept(start)
        XCTAssertEqual(coordinator.route, reopened, "The same generation start must remain suppressed")
        XCTAssertThrowsError(try coordinator.start(sources[0].id, from: reopened)) { error in
            guard case ExecutionError.anotherRunning = error else { return XCTFail("Wrong error: \(error)") }
        }
        XCTAssertEqual(recorder.active, running)
        coordinator.dismissRoute()
        XCTAssertFalse(coordinator.deferred, "Duplicate queued body requests must not create a second pending presentation")
        await idle(coordinator)
    }

}
