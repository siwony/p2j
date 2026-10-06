import Foundation

struct OccurrenceSnapshot: Identifiable, Equatable {
    enum Status: String { case planned, running, paused, completed, skipped }
    let id: UUID
    let routineID: UUID
    let name: String
    let expectedMinutes: Int?
    let firstAction: String?
    let day: LocalDate
    let time: LocalTime?
    let status: Status
    let updatedAt: Date

    init(_ model: PlannedOccurrence) throws {
        guard let day = LocalDate(key: model.plannedDayKey), let status = Status(rawValue: model.statusRaw) else {
            throw PlanError.invalidStoredData
        }
        if let minutes = model.localTimeMinutes, LocalTime(minutes: minutes) == nil { throw PlanError.invalidStoredData }
        id = model.id; routineID = model.routineID; name = model.nameSnapshot
        expectedMinutes = model.expectedMinutesSnapshot; firstAction = model.firstActionSnapshot
        self.day = day; time = model.localTimeMinutes.flatMap(LocalTime.init(minutes:))
        self.status = status; updatedAt = model.updatedAt
    }
    var canReplan: Bool { status == .planned || status == .paused }
    var isUnfinished: Bool { canReplan || status == .running }
    var statusLabel: String {
        switch status {
        case .planned: "예정"
        case .running: "실행 중"
        case .paused: "일시정지"
        case .completed: "완료"
        case .skipped: "쉬기로 한 일정"
        }
    }
}
