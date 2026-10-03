import Foundation
import SwiftData

/// Persisted V1 contract. Future model changes belong in a new schema version.
enum HanjuSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] { [RoutineTemplate.self] }

    @Model
    final class RoutineTemplate {
        @Attribute(.unique) var id: UUID
        var name: String
        var category: String?
        var expectedMinutes: Int?
        var weeklyFrequency: Int?
        var preferredWeekdays: [Int]
        var note: String?
        var firstAction: String?
        var isArchived: Bool
        var createdAt: Date
        var updatedAt: Date

        init(name: String, id: UUID = UUID(), now: Date = .now) {
            self.id = id
            self.name = name
            category = nil
            expectedMinutes = nil
            weeklyFrequency = nil
            preferredWeekdays = []
            note = nil
            firstAction = nil
            isArchived = false
            createdAt = now
            updatedAt = now
        }
    }
}
