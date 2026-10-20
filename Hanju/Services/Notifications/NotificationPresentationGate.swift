import SwiftUI

private struct NotificationPresentationGate: ViewModifier {
    @Environment(NotificationCoordinator.self) private var notifications
    let owner: String
    let blocked: Bool
    func body(content: Content) -> some View {
        content.onChange(of: blocked, initial: true) { notifications.setPresentationBlocked(owner: owner, blocked: blocked) }
    }
}
extension View {
    func notificationPresentation(owner: String, blocked: Bool) -> some View {
        modifier(NotificationPresentationGate(owner: owner, blocked: blocked))
    }
}
struct RecordsNotificationRequest: Equatable {
    let id = UUID()
    let week: LocalDate
}
