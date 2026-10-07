import Foundation
import Observation
import SwiftData

/// App-lifetime command owner. No command suspends; ticks never write storage.
@MainActor @Observable
final class ExecutionRecorder {
    private let container: ModelContainer
    @ObservationIgnored private let clock: () -> ExecutionClock.Sample
    private(set) var active: ExecutionSnapshot?
    private(set) var revision = 0
    private(set) var failure: String?
    init(container: ModelContainer, clock: @escaping () -> ExecutionClock.Sample = ExecutionClock.now) {
        self.container = container; self.clock = clock
        _ = clock() // Establish the process recovery anchor when the app service opens.
        refresh()
    }
    func now() -> ExecutionClock.Sample { clock() }
    func read(_ id: UUID) throws -> ExecutionSnapshot { try ExecutionWriter.snapshot(id, in: ModelContext(container)) }
    func completed(on day: LocalDate) throws -> [ExecutionSnapshot] { try ExecutionWriter.completed(on: day, in: ModelContext(container)) }
    func refresh() {
        do { active = try ExecutionWriter.active(in: ModelContext(container)); failure = nil; revision += 1 }
        catch { failure = error.localizedDescription }
    }
    func start(_ source: ExecutionSnapshot, replacing current: ExecutionSnapshot? = nil) throws {
        try ExecutionWriter.start(source, replacing: current, at: clock(), in: ModelContext(container)); refresh()
    }
    func pause(_ source: ExecutionSnapshot) throws {
        try ExecutionWriter.pause(source, at: clock(), in: ModelContext(container)); refresh()
    }
    func complete(_ source: ExecutionSnapshot) throws {
        try ExecutionWriter.complete(source, at: clock(), in: ModelContext(container)); refresh()
    }
    func undo(_ source: ExecutionSnapshot) throws {
        try ExecutionWriter.undo(source, at: clock(), in: ModelContext(container)); refresh()
    }
    func edit(_ source: ExecutionSnapshot, draft: CompletionDraft) throws {
        try ExecutionWriter.edit(source, draft: draft, today: LocalDate(clock().wall), in: ModelContext(container)); refresh()
    }
}
