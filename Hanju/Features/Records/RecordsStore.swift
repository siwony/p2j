import Foundation
import SwiftData

@MainActor
enum RecordsStore {
    static func fetch(week: LocalDate, in context: ModelContext, at sample: ExecutionClock.Sample) throws -> WeeklyRecordsSnapshot {
        let monday = week.monday, first = monday.key, last = monday.adding(days: 6).key
        let reader = isolatedContext(in: context)
        let request = FetchDescriptor<ExecutionRecord>(predicate: #Predicate {
            ($0.performedDayKey ?? 0) >= first && ($0.performedDayKey ?? 0) <= last
        })
        let records = try reader.fetch(request)
        var seen = Set<UUID>()
        var completed: [ExecutionSnapshot] = []
        for record in records where seen.insert(record.occurrenceID).inserted {
            let source = try ExecutionWriter.snapshot(record.occurrenceID, in: reader)
            guard source.occurrence.status == .completed else { continue }
            guard let day = source.performedOn, day >= monday, day <= monday.adding(days: 6),
                  source.completedAt != nil, source.completionDay != nil,
                  source.intervals.allSatisfy({ $0.endedAt != nil }) else { throw ExecutionError.invalidData }
            completed.append(source)
        }
        completed.sort {
            if $0.performedOn != $1.performedOn { return ($0.performedOn?.key ?? 0) < ($1.performedOn?.key ?? 0) }
            if $0.completedAt != $1.completedAt { return ($0.completedAt ?? .distantPast) < ($1.completedAt ?? .distantPast) }
            return $0.id.uuidString < $1.id.uuidString
        }

        var counts: [UUID: RoutineCount] = [:]
        var total = 0.0, hasRecordedTime = false, overflow = false
        var unrecorded = 0, needsReview = 0
        for source in completed {
            let routineID = source.occurrence.routineID
            counts[routineID] = RoutineCount(routineID: routineID, name: source.occurrence.name,
                                            count: (counts[routineID]?.count ?? 0) + 1)
            let duration = source.duration(at: sample)
            if duration.needsReview { needsReview += 1 }
            else if duration.seconds == nil { unrecorded += 1 }
            if let seconds = duration.seconds {
                hasRecordedTime = true
                if !overflow {
                    let next = total + seconds
                    if next.isFinite { total = next }
                    else { overflow = true }
                }
            }
        }
        let ids = completed.map(\.id)
        var moved = Set<UUID>()
        if !ids.isEmpty {
            let moves = try reader.fetch(FetchDescriptor<OccurrenceDateMove>(predicate: #Predicate { ids.contains($0.occurrenceID) }))
            for evidence in moves {
                guard LocalDate(key: evidence.fromDayKey) != nil, LocalDate(key: evidence.toDayKey) != nil,
                      evidence.fromDayKey != evidence.toDayKey else { throw PlanError.invalidStoredData }
                moved.insert(evidence.occurrenceID)
            }
        }
        let routineCounts = counts.values.sorted {
            if $0.name != $1.name { return $0.name < $1.name }
            return $0.routineID.uuidString < $1.routineID.uuidString
        }
        return WeeklyRecordsSnapshot(week: monday, completed: completed, movedOccurrenceIDs: moved,
            routineCounts: routineCounts, timeSummary: RecordedTimeSummary(
                totalSeconds: hasRecordedTime && !overflow ? total : nil,
                unrecordedCount: unrecorded, needsReviewCount: needsReview, sumOverflow: overflow))
    }

    static func fetchMemo(week: LocalDate, in context: ModelContext) throws -> WeeklyMemoSnapshot {
        let monday = week.monday
        let reader = isolatedContext(in: context)
        return try WeeklyMemoSnapshot(week: monday, body: memo(for: monday, in: reader)?.body ?? "")
    }

    /// Synchronous isolated save. The caller keeps its raw draft until this returns successfully.
    static func saveMemo(week: LocalDate, body: String, in context: ModelContext,
                         save: ((ModelContext) throws -> Void)? = nil) throws -> WeeklyMemoSnapshot {
        let monday = week.monday
        let transaction = isolatedContext(in: context)
        if let existing = try memo(for: monday, in: transaction) {
            if existing.body == body { return WeeklyMemoSnapshot(week: monday, body: body) }
            existing.body = body
        } else {
            if body.isEmpty { return WeeklyMemoSnapshot(week: monday, body: body) }
            transaction.insert(WeeklyMemo(mondayKey: monday.key, body: body))
        }
        do { if let save { try save(transaction) } else { try transaction.save() } }
        catch { transaction.rollback(); throw error }
        return WeeklyMemoSnapshot(week: monday, body: body)
    }

    private static func memo(for week: LocalDate, in context: ModelContext) throws -> WeeklyMemo? {
        let key = week.key
        return try context.fetch(FetchDescriptor<WeeklyMemo>(predicate: #Predicate { $0.mondayKey == key })).first
    }

    private static func isolatedContext(in context: ModelContext) -> ModelContext {
        let isolated = ModelContext(context.container)
        isolated.autosaveEnabled = false
        return isolated
    }
}
