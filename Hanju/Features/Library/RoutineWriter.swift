import Foundation
import SwiftData

@MainActor
enum RoutineWriter {
    /// A fresh context prevents failed commands from rolling back unrelated edits.
    /// Reads return value copies so a previous context cannot show stale edited objects.
    static func fetch(in context: ModelContext, archived: Bool) throws -> [RoutineSnapshot] {
        let reader = ModelContext(context.container)
        let request = FetchDescriptor<RoutineTemplate>(
            predicate: #Predicate { $0.isArchived == archived },
            sortBy: [SortDescriptor(\.createdAt), SortDescriptor(\.name)]
        )
        return try reader.fetch(request).map(RoutineSnapshot.init)
    }

    static func create(
        from draft: RoutineDraft, in context: ModelContext,
        save: (() throws -> Void)? = nil
    ) throws {
        try persist(draft, updating: false, in: context, save: save.map { action in { _ in try action() } })
    }

    static func persist(
        _ draft: RoutineDraft, updating: Bool, in context: ModelContext,
        save: ((ModelContext) throws -> Void)? = nil
    ) throws {
        try draft.validate()
        let transaction = ModelContext(context.container)
        transaction.autosaveEnabled = false
        let existing = try find(draft.id, in: transaction)
        if !updating, existing != nil { return } // Same create command retried after success.
        if updating, existing == nil { throw WriteError.missingRoutine }
        let name = try draft.validatedName()
        let routine = existing ?? RoutineTemplate(name: name, id: draft.id)
        if existing == nil { transaction.insert(routine) }
        routine.name = try draft.validatedName()
        routine.category = draft.category
        routine.expectedMinutes = try draft.optionalPositiveInteger(draft.expectedMinutesText, field: .expectedMinutes)
        routine.weeklyFrequency = try draft.optionalPositiveInteger(draft.weeklyFrequencyText, field: .weeklyFrequency)
        routine.preferredWeekdays = draft.preferredWeekdays.sorted()
        routine.note = optionalText(draft.note)
        routine.firstAction = optionalText(draft.firstAction)
        routine.updatedAt = .now
        try commit(transaction, save: save)
    }

    static func setArchived(
        _ archived: Bool, id: UUID, in context: ModelContext,
        save: ((ModelContext) throws -> Void)? = nil
    ) throws {
        let transaction = ModelContext(context.container)
        transaction.autosaveEnabled = false
        guard let routine = try find(id, in: transaction) else { throw WriteError.missingRoutine }
        guard routine.isArchived != archived else { return }
        routine.isArchived = archived
        routine.updatedAt = .now
        try commit(transaction, save: save)
    }

    private static func find(_ id: UUID, in context: ModelContext) throws -> RoutineTemplate? {
        var request = FetchDescriptor<RoutineTemplate>(predicate: #Predicate { $0.id == id })
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private static func optionalText(_ value: String) -> String? {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : value
    }

    private static func commit(_ context: ModelContext, save: ((ModelContext) throws -> Void)?) throws {
        do {
            if let save { try save(context) } else { try context.save() }
        } catch {
            context.rollback()
            throw error
        }
    }

    enum WriteError: LocalizedError {
        case missingRoutine
        var errorDescription: String? { "이 루틴을 찾지 못했어요. 입력한 내용은 그대로예요." }
    }
}
