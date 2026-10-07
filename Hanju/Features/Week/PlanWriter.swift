import Foundation
import SwiftData

/// Commands do not suspend. Each owns a fresh context, so failure cannot roll back another editor.
@MainActor
enum PlanWriter {
    static func fetch(week: LocalDate, in context: ModelContext) throws -> [OccurrenceSnapshot] {
        let first = week.monday.key, last = week.monday.adding(days: 6).key
        let reader = ModelContext(context.container)
        let request = FetchDescriptor<PlannedOccurrence>(predicate: #Predicate { $0.plannedDayKey >= first && $0.plannedDayKey <= last }, sortBy: [SortDescriptor(\.plannedDayKey), SortDescriptor(\.createdAt)])
        return try reader.fetch(request).map(OccurrenceSnapshot.init).sorted {
            if $0.day != $1.day { return $0.day < $1.day }
            return ($0.time?.minutes ?? -1) < ($1.time?.minutes ?? -1)
        }
    }

    static func confirm(_ draft: PlanDraft, in context: ModelContext, save: ((ModelContext) throws -> Void)? = nil) throws {
        try draft.validate()
        let transaction = transaction(in: context)
        let ids = draft.entries.map(\.id)
        let existing = try transaction.fetch(FetchDescriptor<PlannedOccurrence>(predicate: #Predicate { ids.contains($0.id) }))
        // Retrying a fully committed command must not undo later moves, skips or edits.
        if existing.count == ids.count { return }
        guard existing.isEmpty else { throw PlanError.changedOccurrence }
        let routineIDs = Array(Set(draft.entries.map(\.routineID)))
        let routines = try transaction.fetch(FetchDescriptor<RoutineTemplate>(predicate: #Predicate { routineIDs.contains($0.id) && !$0.isArchived }))
        guard routines.count == routineIDs.count else { throw PlanError.inactiveRoutine }
        let week = try weekPlan(for: draft.week, in: transaction)
        for entry in draft.entries {
            transaction.insert(PlannedOccurrence(id: entry.id, weekID: week.id, routineID: entry.routineID,
                name: entry.name, expectedMinutes: entry.expectedMinutes, firstAction: entry.firstAction,
                day: entry.day, time: entry.time))
        }
        try commit(transaction, save: save)
    }

    static func move(_ source: OccurrenceSnapshot, to day: LocalDate, time: LocalTime?, restore: Bool = false,
                     in context: ModelContext, at sample: ExecutionClock.Sample = ExecutionClock.now(), save: ((ModelContext) throws -> Void)? = nil) throws {
        let transaction = transaction(in: context)
        let model = try find(source.id, in: transaction)
        if model.plannedDayKey == day.key, model.localTimeMinutes == time?.minutes,
           restore ? model.statusRaw != "skipped" : model.statusRaw == source.status.rawValue {
            // Only a matching version, or a successful retry of this move, is a no-op.
            if model.statusRaw != "running", model.statusRaw != "completed" { return }
        }
        try check(source, model: model)
        guard restore ? model.statusRaw == "skipped" : source.isUnfinished else { throw PlanError.changedOccurrence }
        if model.statusRaw == "running" {
            try ExecutionWriter.closeRunning(model, at: sample, in: transaction)
            model.statusRaw = "paused"
        }
        let week = try weekPlan(for: day.monday, in: transaction)
        model.weekID = week.id; model.plannedDayKey = day.key; model.localTimeMinutes = time?.minutes
        if restore {
            model.statusRaw = try ExecutionWriter.hasIntervals(model.id, in: transaction) ? "paused" : "planned"
            model.statusBeforeSkip = nil
        }
        model.updatedAt = .now
        try commit(transaction, save: save)
    }

    static func skip(_ source: OccurrenceSnapshot, in context: ModelContext, at sample: ExecutionClock.Sample = ExecutionClock.now(), save: ((ModelContext) throws -> Void)? = nil) throws {
        let transaction = transaction(in: context)
        let model = try find(source.id, in: transaction)
        if model.statusRaw == "skipped" { return }
        try check(source, model: model)
        try markSkipped(model, at: sample, in: transaction)
        try commit(transaction, save: save)
    }

    /// The confirmation owns this exact ID set; later additions are not swept into it.
    static func rest(_ sources: [OccurrenceSnapshot], today: LocalDate, in context: ModelContext,
                     at sample: ExecutionClock.Sample = ExecutionClock.now(), save: ((ModelContext) throws -> Void)? = nil) throws {
        guard !sources.isEmpty else { return } // Empty-week rest never persists a plan.
        guard Set(sources.map(\.id)).count == sources.count,
              sources.allSatisfy({ $0.day.monday == today.monday && $0.isUnfinished }) else { throw PlanError.invalidDraft }
        let transaction = transaction(in: context)
        for source in sources {
            let model = try find(source.id, in: transaction)
            if model.statusRaw == "skipped" { continue }
            try check(source, model: model)
            try markSkipped(model, at: sample, in: transaction)
        }
        try commit(transaction, save: save)
    }

    static func replan(_ sources: [OccurrenceSnapshot], to day: LocalDate, today: LocalDate,
                       in context: ModelContext, save: ((ModelContext) throws -> Void)? = nil) throws {
        guard day >= today, day.monday == today.monday, !sources.isEmpty,
              Set(sources.map(\.id)).count == sources.count,
              sources.allSatisfy({ $0.day < today && $0.day.monday == today.monday && $0.canReplan }) else { throw PlanError.invalidDate }
        let transaction = transaction(in: context)
        for source in sources {
            let model = try find(source.id, in: transaction)
            if model.plannedDayKey == day.key, model.statusRaw == source.status.rawValue { continue }
            try check(source, model: model)
            model.plannedDayKey = day.key
            model.updatedAt = .now
        }
        try commit(transaction, save: save)
    }

    private static func transaction(in context: ModelContext) -> ModelContext {
        let transaction = ModelContext(context.container)
        transaction.autosaveEnabled = false
        return transaction
    }
    private static func weekPlan(for day: LocalDate, in context: ModelContext) throws -> WeekPlan {
        let mondayKey = day.monday.key
        let request = FetchDescriptor<WeekPlan>(predicate: #Predicate { $0.mondayKey == mondayKey })
        if let existing = try context.fetch(request).first { return existing }
        let week = WeekPlan(mondayKey: mondayKey)
        context.insert(week)
        return week
    }
    private static func find(_ id: UUID, in context: ModelContext) throws -> PlannedOccurrence {
        let request = FetchDescriptor<PlannedOccurrence>(predicate: #Predicate { $0.id == id })
        guard let model = try context.fetch(request).first else { throw PlanError.missingOccurrence }
        return model
    }
    private static func check(_ source: OccurrenceSnapshot, model: PlannedOccurrence) throws {
        guard model.updatedAt == source.updatedAt, model.plannedDayKey == source.day.key,
              model.statusRaw == source.status.rawValue else { throw PlanError.changedOccurrence }
    }
    private static func markSkipped(_ model: PlannedOccurrence, at sample: ExecutionClock.Sample, in context: ModelContext) throws {
        if model.statusRaw == "running" {
            try ExecutionWriter.closeRunning(model, at: sample, in: context)
            model.statusRaw = "paused"
        }
        guard ["planned", "paused"].contains(model.statusRaw) else { throw PlanError.changedOccurrence }
        model.statusBeforeSkip = model.statusRaw
        model.statusRaw = "skipped"
        model.updatedAt = .now
    }
    private static func commit(_ context: ModelContext, save: ((ModelContext) throws -> Void)?) throws {
        do { if let save { try save(context) } else { try context.save() } }
        catch { context.rollback(); throw error }
    }
}
