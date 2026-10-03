import Foundation

struct RoutineDraft {
    var name = ""

    var hasChanges: Bool { !name.isEmpty }

    func validatedName() throws -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ValidationError.emptyName }
        return trimmed
    }

    enum ValidationError: LocalizedError {
        case emptyName

        var errorDescription: String? { "루틴 이름을 입력해주세요." }
    }
}
