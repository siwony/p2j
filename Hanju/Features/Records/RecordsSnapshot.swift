import Foundation

struct WeeklyMemoSnapshot: Equatable {
    let week: LocalDate
    let body: String
}

struct RoutineCount: Identifiable, Equatable {
    let routineID: UUID
    let name: String
    let count: Int
    var id: UUID { routineID }
}

struct RecordedTimeSummary: Equatable {
    let totalSeconds: Double?
    let unrecordedCount: Int
    let needsReviewCount: Int
    let sumOverflow: Bool
}

struct WeeklyRecordsSnapshot: Equatable {
    let week: LocalDate
    let completed: [ExecutionSnapshot]
    let movedOccurrenceIDs: Set<UUID>
    let routineCounts: [RoutineCount]
    let timeSummary: RecordedTimeSummary
}
