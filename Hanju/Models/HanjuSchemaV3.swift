import Foundation
import SwiftData

enum HanjuSchemaV3: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(3, 0, 0) }
    static var models: [any PersistentModel.Type] {
        HanjuSchemaV2.models + [ExecutionRecord.self, ExecutionInterval.self]
    }

    @Model final class ExecutionRecord {
        @Attribute(.unique) var occurrenceID: UUID
        var completedAt: Date?
        var completionDayKey: Int?
        var performedDayKey: Int?
        var manualSeconds: Double?
        var manualThroughSequence: Int?
        var revision: Int
        init(occurrenceID: UUID) {
            self.occurrenceID = occurrenceID
            revision = 0
        }
    }

    @Model final class ExecutionInterval {
        @Attribute(.unique) var id: UUID
        var occurrenceID: UUID
        var sequence: Int
        var startedAt: Date
        var endedAt: Date?
        var startNanoseconds: Int64
        var endNanoseconds: Int64?
        var processID: UUID
        var elapsedSeconds: Double?
        var recoveryNeedsReview: Bool = false
        init(occurrenceID: UUID, sequence: Int, sample: ExecutionClock.Sample) {
            id = UUID(); self.occurrenceID = occurrenceID; self.sequence = sequence
            startedAt = sample.wall; startNanoseconds = sample.nanoseconds; processID = sample.processID
        }
    }
}

typealias ExecutionRecord = HanjuSchemaV3.ExecutionRecord
typealias ExecutionInterval = HanjuSchemaV3.ExecutionInterval
