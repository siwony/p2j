import Foundation
import SwiftData

/// Earlier model definitions stay frozen; V4 adds only memo and observed date-move evidence.
enum HanjuSchemaV4: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(4, 0, 0) }
    static var models: [any PersistentModel.Type] {
        HanjuSchemaV3.models + [WeeklyMemo.self, OccurrenceDateMove.self]
    }

    @Model final class WeeklyMemo {
        @Attribute(.unique) var mondayKey: Int
        var body: String
        init(mondayKey: Int, body: String) {
            self.mondayKey = mondayKey
            self.body = body
        }
    }

    /// The first observed successful date move. Absence does not prove an older item never moved.
    @Model final class OccurrenceDateMove {
        @Attribute(.unique) var occurrenceID: UUID
        var fromDayKey: Int
        var toDayKey: Int
        init(occurrenceID: UUID, fromDayKey: Int, toDayKey: Int) {
            self.occurrenceID = occurrenceID
            self.fromDayKey = fromDayKey
            self.toDayKey = toDayKey
        }
    }
}

typealias WeeklyMemo = HanjuSchemaV4.WeeklyMemo
typealias OccurrenceDateMove = HanjuSchemaV4.OccurrenceDateMove
