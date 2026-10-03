import SwiftData

@MainActor
enum RoutineWriter {
    /// Each insert uses its own context so a failed save cannot roll back other edits.
    /// The editor keeps its draft outside SwiftData for another attempt.
    static func create(
        from draft: RoutineDraft,
        in context: ModelContext,
        save: (() throws -> Void)? = nil
    ) throws {
        let name = try draft.validatedName()
        let transaction = ModelContext(context.container)
        transaction.autosaveEnabled = false
        let routine = RoutineTemplate(name: name)
        transaction.insert(routine)
        do {
            if let save {
                try save()
            } else {
                try transaction.save()
            }
        } catch {
            transaction.rollback()
            throw error
        }
    }
}
