import Darwin
import Foundation

enum ExecutionClock {
    struct Sample: Equatable {
        let wall: Date
        let nanoseconds: Int64
        let processID: UUID
        var launchWall: Date?
        var launchNanoseconds: Int64?
    }
    private static let processID = UUID()
    private static let launch = (wall: Date.now, nanoseconds: Int64(clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW)))
    static func now() -> Sample {
        let anchor = launch
        return Sample(wall: .now, nanoseconds: Int64(clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW)), processID: processID, launchWall: anchor.wall, launchNanoseconds: anchor.nanoseconds)
    }
    /// Raw continuous time includes sleep.
    // ponytail: Launch-sample agreement is a heuristic; replace with a public boot-session ID if one becomes available.
    static func elapsed(start: Sample, end: Sample) -> Double? {
        guard start.nanoseconds >= 0, end.nanoseconds >= start.nanoseconds else { return nil }
        let seconds = Double(end.nanoseconds - start.nanoseconds) / 1_000_000_000
        if start.processID != end.processID {
            // Assess recovery once against this process's launch sample; later wall changes do not alter it.
            let anchorRaw = end.launchNanoseconds ?? end.nanoseconds
            let anchorWall = end.launchWall ?? end.wall
            guard anchorRaw >= start.nanoseconds else { return nil }
            let anchorElapsed = Double(anchorRaw - start.nanoseconds) / 1_000_000_000
            guard abs(anchorWall.timeIntervalSince(start.wall) - anchorElapsed) <= 5 else { return nil }
        }
        return seconds
    }
}
