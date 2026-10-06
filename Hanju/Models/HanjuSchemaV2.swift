import Foundation
import SwiftData

/// V1 is frozen. Its unchanged routine entity is reused without altering its storage contract.
enum HanjuSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(2, 0, 0) }
    static var models: [any PersistentModel.Type] {
        [HanjuSchemaV1.RoutineTemplate.self, WeekPlan.self, PlannedOccurrence.self]
    }

    @Model final class WeekPlan {
        @Attribute(.unique) var id: UUID
        @Attribute(.unique) var mondayKey: Int
        var calendarConnected: Bool
        var createdAt: Date
        init(mondayKey: Int, id: UUID = UUID(), now: Date = .now) {
            self.id = id; self.mondayKey = mondayKey
            calendarConnected = false; createdAt = now
        }
    }

    @Model final class PlannedOccurrence {
        @Attribute(.unique) var id: UUID
        var weekID: UUID
        var routineID: UUID
        var nameSnapshot: String
        var expectedMinutesSnapshot: Int?
        var firstActionSnapshot: String?
        var plannedDayKey: Int
        var localTimeMinutes: Int?
        var statusRaw: String
        var statusBeforeSkip: String?
        var createdAt: Date
        var updatedAt: Date
        init(id: UUID, weekID: UUID, routineID: UUID, name: String, expectedMinutes: Int?, firstAction: String?, day: LocalDate, time: LocalTime?, now: Date = .now) {
            self.id = id; self.weekID = weekID; self.routineID = routineID
            nameSnapshot = name; expectedMinutesSnapshot = expectedMinutes; firstActionSnapshot = firstAction
            plannedDayKey = day.key; localTimeMinutes = time?.minutes
            statusRaw = "planned"; statusBeforeSkip = nil
            createdAt = now; updatedAt = now
        }
    }
}

typealias WeekPlan = HanjuSchemaV2.WeekPlan
typealias PlannedOccurrence = HanjuSchemaV2.PlannedOccurrence

enum HanjuMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [HanjuSchemaV1.self, HanjuSchemaV2.self] }
    static var stages: [MigrationStage] { [.lightweight(fromVersion: HanjuSchemaV1.self, toVersion: HanjuSchemaV2.self)] }
}
