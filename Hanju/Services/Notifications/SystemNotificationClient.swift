import Foundation
import UIKit
import UserNotifications

struct NotificationSystemSnapshot {
    enum Authorization: String { case notDetermined, denied, authorized, provisional, ephemeral, unknown }
    struct Request: Equatable { let id: String; let generation: UUID? }
    let authorization: Authorization
    let pending: [Request]
    let delivered: [Request]
    var allowsScheduling: Bool { [.authorized, .provisional, .ephemeral].contains(authorization) }
}

@MainActor
protocol NotificationClient {
    func snapshot() async -> NotificationSystemSnapshot
    func authorize() async throws
    func add(_ ticket: NotificationTicket) async throws
    func removePending(_ ids: [String])
    func removeDelivered(_ ids: [String])
}

@MainActor
final class SystemNotificationClient: NotificationClient {
    private let center = UNUserNotificationCenter.current()
    func snapshot() async -> NotificationSystemSnapshot {
        let settings = await center.notificationSettings()
        let pending = await center.pendingNotificationRequests()
        let delivered = await center.deliveredNotifications()
        let authorization: NotificationSystemSnapshot.Authorization
        switch settings.authorizationStatus {
        case .notDetermined: authorization = .notDetermined
        case .denied: authorization = .denied
        case .authorized: authorization = .authorized
        case .provisional: authorization = .provisional
        case .ephemeral: authorization = .ephemeral
        @unknown default: authorization = .unknown
        }
        return .init(authorization: authorization, pending: pending.map(Self.summary),
                     delivered: delivered.map { Self.summary($0.request) })
    }
    func authorize() async throws { _ = try await center.requestAuthorization(options: [.alert, .sound]) }
    func add(_ ticket: NotificationTicket) async throws {
        let content = UNMutableNotificationContent()
        content.title = ticket.isPlanning ? "다음 주를 가볍게 골라볼까요?" : (ticket.targets.count == 1 ? ticket.targets[0].name : "오늘 정해둔 일")
        content.body = ticket.isPlanning ? "이번 주 해낸 일과 메모를 보고, 다음 주에 할 일을 골라보세요." : "한 가지를 시작하거나 30분 뒤에 다시 볼 수 있어요."
        content.sound = .default
        content.categoryIdentifier = ticket.isPlanning ? "hanju.planning" : "hanju.execution"
        content.userInfo = ["generation": ticket.generation.uuidString]
        let trigger: UNCalendarNotificationTrigger
        if ticket.isPlanning, let weekday = ticket.weekday, let minutes = ticket.minutes {
            var parts = DateComponents()
            parts.calendar = Calendar(identifier: .gregorian)
            parts.timeZone = TimeZone(identifier: ticket.timeZoneID)
            parts.weekday = weekday % 7 + 1; parts.hour = minutes / 60; parts.minute = minutes % 60
            trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: true)
        } else {
            var calendar = Calendar(identifier: .gregorian); calendar.timeZone = .gmt
            var parts = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: ticket.dueAt)
            parts.calendar = calendar; parts.timeZone = .gmt
            trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
            guard let next = trigger.nextTriggerDate(), abs(next.timeIntervalSince(ticket.dueAt)) < 1 else { throw NotificationFailure.trigger }
        }
        try await center.add(UNNotificationRequest(identifier: ticket.id, content: content, trigger: trigger))
    }
    func removePending(_ ids: [String]) { center.removePendingNotificationRequests(withIdentifiers: ids) }
    func removeDelivered(_ ids: [String]) { center.removeDeliveredNotifications(withIdentifiers: ids) }
    private static func summary(_ request: UNNotificationRequest) -> NotificationSystemSnapshot.Request {
        .init(id: request.identifier, generation: (request.content.userInfo["generation"] as? String).flatMap(UUID.init(uuidString:)))
    }
}

/// The launch bridge outlives UNUserNotificationCenter's weak delegate reference.
@MainActor
final class NotificationAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let persistence = PersistenceStore()
    let notifications = NotificationCoordinator()
    func openServices() {
        persistence.open()
        if let container = persistence.container, let recorder = persistence.recorder { notifications.attach(container: container, recorder: recorder) }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        // Snooze needs no further choice; authentication permits protected local storage access.
        let start = UNNotificationAction(identifier: "start", title: "시작", options: [.foreground])
        let snooze = UNNotificationAction(identifier: "snooze", title: "30분 뒤 다시 알림", options: [.authenticationRequired])
        center.setNotificationCategories([
            UNNotificationCategory(identifier: "hanju.execution", actions: [start, snooze], intentIdentifiers: []),
            UNNotificationCategory(identifier: "hanju.planning", actions: [], intentIdentifiers: [])
        ])
        openServices()
        return true
    }
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                            withCompletionHandler completionHandler: @escaping () -> Void) {
        let request = response.notification.request
        let action: NotificationEnvelope.Action?
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier: action = .open
        case "start": action = .start
        case "snooze": action = .snooze
        default: action = nil
        }
        if let action, let text = request.content.userInfo["generation"] as? String, let generation = UUID(uuidString: text) {
            let envelope = NotificationEnvelope(requestID: request.identifier, generation: generation, action: action)
            let completion = NotificationCompletion(completionHandler)
            Task { @MainActor [weak self] in
                guard let self else { completion.finish(); return }
                let deadline = ContinuousClock.now.advanced(by: .seconds(5))
                let timeout = Task { @MainActor [weak self] in
                    do { try await Task.sleep(until: deadline, clock: .continuous) } catch { return }
                    self?.notifications.noteResponseTimeout()
                    completion.finish()
                }
                self.openServices()
                if action == .snooze {
                    self.notifications.acceptSnooze(envelope)
                    await self.notifications.waitForReconciliation(until: deadline)
                } else { NotificationInbox.shared.receive(envelope) }
                timeout.cancel()
                completion.finish()
            }
            return
        }
        completionHandler() // Exactly once; no model access or user-choice wait in this callback.
    }
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let requestID = notification.request.identifier
        let generation = (notification.request.content.userInfo["generation"] as? String).flatMap(UUID.init(uuidString:))
        let completion = NotificationPresentationCompletion(completionHandler)
        Task { @MainActor [weak self] in
            let show = generation.map { self?.notifications.shouldPresent(.init(requestID: requestID, generation: $0, action: .open)) == true } ?? false
            completion.finish(show ? [.banner, .sound] : [])
        }
    }
}

@MainActor
final class NotificationInbox {
    static let shared = NotificationInbox()
    private var queued: [NotificationEnvelope] = []
    private var receiver: ((NotificationEnvelope) -> Void)?
    func receive(_ envelope: NotificationEnvelope) {
        if let receiver { receiver(envelope) }
        else if !queued.contains(envelope) { queued.append(envelope) }
    }
    func attach(_ receiver: @escaping (NotificationEnvelope) -> Void) {
        self.receiver = receiver
        let pending = queued; queued = []
        for envelope in pending { receiver(envelope) }
    }
}

/// UN completion blocks cross to the main actor once; no non-Sendable system object crosses.
private final class NotificationCompletion: @unchecked Sendable {
    private let lock = NSLock()
    private var block: (() -> Void)?
    init(_ block: @escaping () -> Void) { self.block = block }
    func finish() {
        lock.lock(); let completion = block; block = nil; lock.unlock()
        completion?()
    }
}
private final class NotificationPresentationCompletion: @unchecked Sendable {
    private let block: (UNNotificationPresentationOptions) -> Void
    init(_ block: @escaping (UNNotificationPresentationOptions) -> Void) { self.block = block }
    func finish(_ options: UNNotificationPresentationOptions) { block(options) }
}
