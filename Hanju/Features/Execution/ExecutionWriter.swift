import Foundation
import SwiftData

@MainActor
enum ExecutionWriter {
    static func snapshot(_ id: UUID, in context: ModelContext) throws -> ExecutionSnapshot {
        let occurrence = try find(id, in: context)
        let record = try record(id, in: context, create: false)
        let intervals = try intervals(id, in: context)
        guard intervals.filter({ $0.endedAt == nil }).count <= 1,
              Set(intervals.map(\.sequence)).count == intervals.count,
              record?.manualSeconds == nil || (record?.manualSeconds?.isFinite == true && (record?.manualSeconds ?? -1) >= 0) else { throw ExecutionError.invalidData }
        return try ExecutionSnapshot(occurrence: OccurrenceSnapshot(occurrence), revision: record?.revision ?? 0,
            completedAt: record?.completedAt, completionDay: record?.completionDayKey.flatMap(LocalDate.init(key:)),
            performedOn: record?.performedDayKey.flatMap(LocalDate.init(key:)), manualSeconds: record?.manualSeconds,
            manualThroughSequence: record?.manualThroughSequence, intervals: intervals.map {
                ExecutionSnapshot.Interval(id: $0.id, sequence: $0.sequence,
                    start: ExecutionClock.Sample(wall: $0.startedAt, nanoseconds: $0.startNanoseconds, processID: $0.processID),
                    endedAt: $0.endedAt, endNanoseconds: $0.endNanoseconds, elapsed: $0.elapsedSeconds)
            })
    }
    static func active(in context: ModelContext) throws -> ExecutionSnapshot? {
        let running = try context.fetch(FetchDescriptor<PlannedOccurrence>(predicate: #Predicate { $0.statusRaw == "running" }))
        guard running.count <= 1 else { throw ExecutionError.invalidData }
        return try running.first.map { try snapshot($0.id, in: context) }
    }
    static func completed(on day: LocalDate, in context: ModelContext) throws -> [ExecutionSnapshot] {
        let key = day.key
        let records = try context.fetch(FetchDescriptor<ExecutionRecord>(predicate: #Predicate { $0.performedDayKey == key }))
        return try records.map { try snapshot($0.occurrenceID, in: context) }
            .filter { $0.occurrence.status == .completed }.sorted { ($0.completedAt ?? .distantPast) < ($1.completedAt ?? .distantPast) }
    }
    static func start(_ source: ExecutionSnapshot, replacing current: ExecutionSnapshot? = nil,
                      at sample: ExecutionClock.Sample, in context: ModelContext, save: ((ModelContext) throws -> Void)? = nil) throws {
        let transaction = transaction(context)
        let model = try find(source.id, in: transaction)
        let prior = try active(in: transaction)
        if prior?.id == source.id, prior?.revision == source.revision + 1 { return }
        try check(source, model: model, in: transaction)
        guard source.occurrence.canReplan else { throw ExecutionError.changed }
        if let prior {
            guard let current, current.id == prior.id else { throw ExecutionError.anotherRunning }
            let old = try find(prior.id, in: transaction)
            try check(current, model: old, in: transaction)
            try closeRunning(old, at: sample, in: transaction)
            old.statusRaw = "paused"; old.updatedAt = sample.wall
        } else if current != nil { throw ExecutionError.changed }
        let record = try requiredRecord(source.id, in: transaction)
        let segments = try intervals(source.id, in: transaction)
        guard segments.allSatisfy({ $0.endedAt != nil }) else { throw ExecutionError.invalidData }
        transaction.insert(ExecutionInterval(occurrenceID: source.id, sequence: (segments.last?.sequence ?? 0) + 1, sample: sample))
        record.revision += 1
        model.statusRaw = "running"; model.updatedAt = sample.wall
        try commit(transaction, save: save)
    }
    static func pause(_ source: ExecutionSnapshot, at sample: ExecutionClock.Sample, in context: ModelContext,
                      save: ((ModelContext) throws -> Void)? = nil) throws {
        let transaction = transaction(context), model = try find(source.id, in: transaction)
        let stored = try snapshot(source.id, in: transaction)
        if stored.occurrence.status == .paused, stored.revision == source.revision + 1 { return }
        try check(source, model: model, in: transaction)
        guard model.statusRaw == "running" else { throw ExecutionError.changed }
        try closeRunning(model, at: sample, in: transaction)
        model.statusRaw = "paused"; model.updatedAt = sample.wall
        try commit(transaction, save: save)
    }
    static func complete(_ source: ExecutionSnapshot, at sample: ExecutionClock.Sample, timeZone: TimeZone = .current,
                         in context: ModelContext, save: ((ModelContext) throws -> Void)? = nil) throws {
        let transaction = transaction(context), model = try find(source.id, in: transaction)
        let stored = try snapshot(source.id, in: transaction)
        if stored.occurrence.status == .completed, stored.revision == source.revision + 1 { return }
        try check(source, model: model, in: transaction)
        guard source.occurrence.isUnfinished else { throw ExecutionError.changed }
        if model.statusRaw == "running" { try closeRunning(model, at: sample, in: transaction) }
        let record = try requiredRecord(source.id, in: transaction)
        record.completedAt = sample.wall
        record.completionDayKey = LocalDate(sample.wall, timeZone: timeZone).key
        record.performedDayKey = record.completionDayKey
        // Closing the active interval already advances the version once.
        if source.occurrence.status != .running { record.revision += 1 }
        model.statusRaw = "completed"; model.updatedAt = sample.wall
        try commit(transaction, save: save)
    }
    static func undo(_ source: ExecutionSnapshot, at sample: ExecutionClock.Sample, in context: ModelContext,
                     save: ((ModelContext) throws -> Void)? = nil) throws {
        let transaction = transaction(context), model = try find(source.id, in: transaction)
        let stored = try snapshot(source.id, in: transaction)
        if stored.occurrence.canReplan, stored.revision == source.revision + 1, stored.completedAt == nil { return }
        try check(source, model: model, in: transaction)
        guard source.occurrence.status == .completed else { throw ExecutionError.changed }
        let record = try requiredRecord(source.id, in: transaction)
        record.completedAt = nil; record.completionDayKey = nil; record.performedDayKey = nil; record.revision += 1
        model.statusRaw = stored.intervals.isEmpty ? "planned" : "paused"; model.updatedAt = sample.wall
        try commit(transaction, save: save)
    }
    static func edit(_ source: ExecutionSnapshot, draft: CompletionDraft, today: LocalDate, in context: ModelContext,
                     save: ((ModelContext) throws -> Void)? = nil) throws {
        guard draft.performedOn <= today else { throw ExecutionError.futureDate }
        let transaction = transaction(context), model = try find(source.id, in: transaction)
        try check(source, model: model, in: transaction)
        guard source.occurrence.status == .completed else { throw ExecutionError.changed }
        let record = try requiredRecord(source.id, in: transaction)
        if draft.minutesEdited {
            record.manualSeconds = try draft.manualSeconds()
            record.manualThroughSequence = record.manualSeconds == nil ? nil : (source.intervals.last?.sequence ?? 0)
        }
        record.performedDayKey = draft.performedOn.key; record.revision += 1
        try commit(transaction, save: save)
    }

    /// Caller owns save. Planning and execution must close the interval in the same transaction.
    static func closeRunning(_ occurrence: PlannedOccurrence, at sample: ExecutionClock.Sample, in context: ModelContext) throws {
        let open = try intervals(occurrence.id, in: context).filter { $0.endedAt == nil }
        guard open.count == 1, let interval = open.first else { throw ExecutionError.invalidData }
        interval.endedAt = sample.wall; interval.endNanoseconds = sample.nanoseconds
        interval.elapsedSeconds = ExecutionClock.elapsed(start: .init(wall: interval.startedAt, nanoseconds: interval.startNanoseconds, processID: interval.processID), end: sample)
        let record = try requiredRecord(occurrence.id, in: context)
        record.revision += 1
    }
    static func hasIntervals(_ id: UUID, in context: ModelContext) throws -> Bool { try !intervals(id, in: context).isEmpty }
    static func find(_ id: UUID, in context: ModelContext) throws -> PlannedOccurrence {
        guard let model = try context.fetch(FetchDescriptor<PlannedOccurrence>(predicate: #Predicate { $0.id == id })).first else { throw PlanError.missingOccurrence }
        return model
    }
    private static func record(_ id: UUID, in context: ModelContext, create: Bool) throws -> ExecutionRecord? {
        if let record = try context.fetch(FetchDescriptor<ExecutionRecord>(predicate: #Predicate { $0.occurrenceID == id })).first { return record }
        if create { let record = ExecutionRecord(occurrenceID: id); context.insert(record); return record }
        return nil
    }
    private static func requiredRecord(_ id: UUID, in context: ModelContext) throws -> ExecutionRecord {
        guard let record = try record(id, in: context, create: true) else { throw ExecutionError.invalidData }; return record
    }
    private static func intervals(_ id: UUID, in context: ModelContext) throws -> [ExecutionInterval] {
        try context.fetch(FetchDescriptor<ExecutionInterval>(predicate: #Predicate { $0.occurrenceID == id }, sortBy: [SortDescriptor(\.sequence)]))
    }
    private static func check(_ source: ExecutionSnapshot, model: PlannedOccurrence, in context: ModelContext) throws {
        let revision = try record(source.id, in: context, create: false)?.revision ?? 0
        guard revision == source.revision, model.updatedAt == source.occurrence.updatedAt,
              model.statusRaw == source.occurrence.status.rawValue else { throw ExecutionError.changed }
    }
    private static func transaction(_ context: ModelContext) -> ModelContext {
        let transaction = ModelContext(context.container); transaction.autosaveEnabled = false; return transaction
    }
    private static func commit(_ context: ModelContext, save: ((ModelContext) throws -> Void)?) throws {
        do { if let save { try save(context) } else { try context.save() } }
        catch { context.rollback(); throw error }
    }
}
