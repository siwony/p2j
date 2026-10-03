import Foundation

/// A value copy for browsing/editing; SwiftData objects never become editable UI drafts.
struct RoutineSnapshot: Identifiable, Equatable {
    let id: UUID
    let draft: RoutineDraft
    let isArchived: Bool
    let createdAt: Date
    let updatedAt: Date

    init(_ routine: RoutineTemplate) {
        id = routine.id
        draft = RoutineDraft(
            id: routine.id, name: routine.name, category: routine.category,
            expectedMinutesText: routine.expectedMinutes.map(String.init) ?? "",
            weeklyFrequencyText: routine.weeklyFrequency.map(String.init) ?? "",
            preferredWeekdays: Set(routine.preferredWeekdays),
            note: routine.note ?? "", firstAction: routine.firstAction ?? ""
        )
        isArchived = routine.isArchived
        createdAt = routine.createdAt
        updatedAt = routine.updatedAt
    }
}
