import Foundation

struct RoutineDraft: Equatable {
    var id = UUID()
    var name = ""
    var category: String?
    var expectedMinutesText = ""
    var weeklyFrequencyText = ""
    /// ISO weekdays: Monday = 1 through Sunday = 7.
    var preferredWeekdays: Set<Int> = []
    var note = ""
    var firstAction = ""

    static let categories = ["집안일", "공부", "생활"]

    func validatedName() throws -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ValidationError(field: .name, message: "루틴 이름을 입력해주세요.") }
        return trimmed
    }

    func optionalPositiveInteger(_ text: String, field: Field) throws -> Int? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard let value = Int(trimmed), value > 0 else {
            throw ValidationError(field: field, message: "1 이상의 정수를 입력하거나 비워두세요.")
        }
        return value
    }

    func validate() throws {
        _ = try validatedName()
        _ = try optionalPositiveInteger(expectedMinutesText, field: .expectedMinutes)
        _ = try optionalPositiveInteger(weeklyFrequencyText, field: .weeklyFrequency)
        guard preferredWeekdays.isSubset(of: Set(1...7)) else {
            throw ValidationError(field: .weekdays, message: "선호 요일을 다시 선택해주세요.")
        }
    }

    enum Field: Hashable {
        case name, expectedMinutes, weeklyFrequency, weekdays, firstAction, note
    }

    struct ValidationError: LocalizedError {
        let field: Field
        let message: String
        var errorDescription: String? { message }
    }
}
