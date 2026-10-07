import Foundation

struct ExecutionSnapshot: Identifiable, Equatable {
    struct Interval: Equatable {
        let id: UUID
        let sequence: Int
        let start: ExecutionClock.Sample
        let endedAt: Date?
        let endNanoseconds: Int64?
        let elapsed: Double?
        let recoveryNeedsReview: Bool
    }
    let occurrence: OccurrenceSnapshot
    let revision: Int
    let completedAt: Date?
    let completionDay: LocalDate?
    let performedOn: LocalDate?
    let manualSeconds: Double?
    let manualThroughSequence: Int?
    let intervals: [Interval]
    var id: UUID { occurrence.id }

    func duration(at sample: ExecutionClock.Sample) -> RecordedDuration {
        var known = manualSeconds ?? 0
        var hasTime = manualSeconds != nil
        var needsReview = false
        for interval in intervals where manualThroughSequence == nil || interval.sequence > (manualThroughSequence ?? 0) {
            hasTime = true
            let elapsed = interval.recoveryNeedsReview ? nil : (interval.endedAt == nil ? ExecutionClock.elapsed(start: interval.start, end: sample) : interval.elapsed)
            if let elapsed, elapsed.isFinite, elapsed >= 0, (known + elapsed).isFinite { known += elapsed }
            else { needsReview = true }
        }
        return RecordedDuration(seconds: needsReview || !hasTime ? nil : known, knownSeconds: known, needsReview: needsReview)
    }
}

struct RecordedDuration: Equatable {
    let seconds: Double?
    let knownSeconds: Double
    let needsReview: Bool
    var label: String {
        if needsReview {
            return knownSeconds > 0 ? "시간 확인 필요 · 확인된 구간 \(Self.format(knownSeconds))" : "시간 확인 필요"
        }
        return seconds.map(Self.format) ?? "시간 미기록"
    }
    static func timerLabel(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "시간 확인 필요" }
        let hours = (seconds / 3600).rounded(.down).formatted(.number.grouping(.never).precision(.fractionLength(0)))
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600) / 60).rounded(.down))
        let remainder = Int(seconds.truncatingRemainder(dividingBy: 60).rounded(.down))
        return "\(hours):\(minutes < 10 ? "0" : "")\(minutes):\(remainder < 10 ? "0" : "")\(remainder)"
    }
    static func format(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "시간 확인 필요" }
        if seconds == 0 { return "0분 기록" }
        if seconds < 60 { return "1분 미만 기록" }
        return "\((seconds / 60).rounded(.down).formatted(.number.precision(.fractionLength(0))))분 기록"
    }
}

struct CompletionDraft: Equatable {
    var performedOn: LocalDate
    var minutes: String { didSet { minutesEdited = true } }
    private(set) var minutesEdited = false
    let originalMinutes: String
    init(_ source: ExecutionSnapshot) {
        performedOn = source.performedOn ?? LocalDate(.now)
        // Measured time is shown separately, never round-tripped through integer minutes.
        minutes = source.manualSeconds == nil ? "" : (source.duration(at: ExecutionClock.now()).seconds.map { String($0 / 60) } ?? "")
        originalMinutes = minutes
    }
    func manualSeconds() throws -> Double? {
        let text = minutes.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { return nil }
        guard text.unicodeScalars.allSatisfy({ CharacterSet(charactersIn: "0123456789.").contains($0) }),
              let value = Double(text), value.isFinite, value >= 0, (value * 60).isFinite else { throw ExecutionError.invalidMinutes }
        return value * 60
    }
}

enum ExecutionError: LocalizedError {
    case changed, invalidData, anotherRunning, invalidMinutes, futureDate
    var errorDescription: String? {
        switch self {
        case .changed: "이 기록이 변경됐어요. 닫고 최신 기록에서 다시 시도해주세요."
        case .invalidData: "실행 기록을 확인하지 못했어요. 기존 데이터는 그대로 보존돼요."
        case .anotherRunning: "다른 일을 기록하고 있어요. 현재 일을 일시정지한 뒤 시작할 수 있어요."
        case .invalidMinutes: "실제 시간은 0 이상의 숫자로 입력해주세요. 입력한 내용은 그대로 남아 있어요."
        case .futureDate: "실제로 한 날짜는 오늘 이후로 정할 수 없어요."
        }
    }
}
