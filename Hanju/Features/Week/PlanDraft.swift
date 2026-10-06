import Foundation

struct PlanDraft: Equatable {
    static let batchLimit = 100
    let week: LocalDate
    var entries: [Entry] = []

    struct Entry: Identifiable, Equatable {
        let id: UUID
        let routineID: UUID
        let name: String
        let expectedMinutes: Int?
        let firstAction: String?
        var day: LocalDate
        var time: LocalTime?

        init(id: UUID = UUID(), routineID: UUID, name: String, expectedMinutes: Int?, firstAction: String?, day: LocalDate, time: LocalTime? = nil) {
            self.id = id; self.routineID = routineID; self.name = name
            self.expectedMinutes = expectedMinutes; self.firstAction = firstAction
            self.day = day; self.time = time
        }
    }

    static func allocate(week: LocalDate, earliest: LocalDate, routines: [RoutineSnapshot],
                         counts: [UUID: String], previous: [OccurrenceSnapshot]) throws -> PlanDraft {
        guard earliest.monday == week, week == week.monday else { throw PlanError.invalidDate }
        let quantities = try validateCounts(routines.map {
            counts[$0.id] ?? ($0.draft.weeklyFrequencyText.isEmpty ? "1" : $0.draft.weeklyFrequencyText)
        }, existing: previous.count)
        var entries: [Entry] = []
        let days = earliest.weekDays.filter { $0 >= earliest }
        for (routine, quantity) in zip(routines, quantities) {
            let preferences = days.filter { routine.draft.preferredWeekdays.contains($0.weekday) }
            let placement = preferences.isEmpty ? days : preferences
            for index in 0..<quantity {
                entries.append(Entry(routineID: routine.id, name: routine.draft.name,
                    expectedMinutes: try routine.draft.optionalPositiveInteger(routine.draft.expectedMinutesText, field: .expectedMinutes),
                    firstAction: routine.draft.firstAction.isEmpty ? nil : routine.draft.firstAction,
                    day: placement[index % placement.count]))
            }
        }
        for item in previous {
            let day = week.adding(days: item.day.weekday - 1)
            entries.append(Entry(routineID: item.routineID, name: item.name, expectedMinutes: item.expectedMinutes,
                firstAction: item.firstAction, day: max(day, earliest), time: item.time))
        }
        return PlanDraft(week: week, entries: entries)
    }

    static func validateCounts(_ rawCounts: [String], existing: Int = 0) throws -> [Int] {
        guard existing <= batchLimit else { throw PlanError.batchLimit }
        var remaining = batchLimit - existing
        var result: [Int] = []
        for raw in rawCounts {
            let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty, trimmed.allSatisfy({ $0.isASCII && $0.isNumber }),
                  let count = Int(trimmed), count > 0 else { throw PlanError.invalidDraft }
            guard count <= remaining else { throw PlanError.batchLimit }
            remaining -= count; result.append(count)
        }
        return result
    }

    func validate() throws {
        guard week == week.monday, !entries.isEmpty, Set(entries.map(\.id)).count == entries.count else {
            throw PlanError.invalidDraft
        }
        guard entries.count <= Self.batchLimit else { throw PlanError.batchLimit }
        for entry in entries {
            guard entry.day.monday == week, !entry.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  entry.expectedMinutes.map({ $0 > 0 }) ?? true else { throw PlanError.invalidDraft }
        }
    }
}

enum PlanError: LocalizedError {
    case inactiveRoutine, batchLimit, invalidDraft, missingOccurrence, changedOccurrence, invalidDate, runningNeedsRecorder, invalidStoredData
    var errorDescription: String? {
        switch self {
        case .inactiveRoutine: "고른 루틴이 보관되었거나 없어졌어요. 입력은 그대로예요. 루틴함에서 확인해주세요."
        case .batchLimit: "한 번에 100회까지 담을 수 있어요. 나누어 추가해주세요."
        case .invalidDraft: "회차와 날짜를 확인해주세요. 입력한 내용은 그대로예요."
        case .missingOccurrence: "이 일정을 찾지 못했어요. 다시 확인해주세요."
        case .changedOccurrence: "일정 상태가 바뀌었어요. 화면을 다시 열어 확인해주세요."
        case .invalidDate: "선택할 수 있는 날짜를 확인해주세요."
        case .runningNeedsRecorder: "실행 중인 일정의 변경은 실행 기록 기능과 함께 제공될 예정이에요. 일정은 그대로예요."
        case .invalidStoredData: "일정 데이터를 읽지 못했어요. 데이터를 지우지 않고 다시 시도할 수 있어요."
        }
    }
}
