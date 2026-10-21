import SwiftData
import SwiftUI

struct AppTabs: View {
    private enum Tab: Hashable {
        case today, week, library, records, settings
    }

    @Environment(NotificationCoordinator.self) private var notifications
    @State private var recordsRequest: RecordsNotificationRequest?
    @State private var selection: Tab = .today
    @State private var weekDay = LocalDate(.now)
    @State private var weekRequest: WeekRequest?
    @State private var memos = WeeklyMemoCoordinator()
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                TodayView(openWeek: { day in weekRequest = WeekRequest(kind: .agenda, day: day); selection = .week },
                    plan: { day in weekRequest = WeekRequest(kind: .plan, day: day); selection = .week },
                    recover: { day in weekRequest = WeekRequest(kind: .recovery, day: day); selection = .week },
                    openLibrary: { selection = .library })
            }
            .tabItem { Label("오늘", systemImage: "sun.max") }
            .tag(Tab.today)

            NavigationStack {
                WeekView(selectedDay: $weekDay, request: $weekRequest,
                    returnToCaller: { selection = $0 == .today ? .today : .records }, openLibrary: { selection = .library })
            }
            .tabItem { Label("이번 주", systemImage: "calendar") }
            .tag(Tab.week)

            NavigationStack { LibraryView() }
                .tabItem { Label("루틴함", systemImage: "square.stack") }
                .tag(Tab.library)

            NavigationStack {
                RecordsView(notificationRequest: $recordsRequest, openWeek: { day in
                    weekRequest = WeekRequest(kind: .agenda, day: day, caller: .records); selection = .week
                }, planNextWeek: { day in
                    weekRequest = WeekRequest(kind: .plan, day: day, caller: .records); selection = .week
                })
            }
            .tabItem { Label("기록", systemImage: "text.book.closed") }
            .tag(Tab.records)

            NavigationStack { SettingsView() }
            .tabItem { Label("설정", systemImage: "gearshape") }
            .tag(Tab.settings)
        }
        .environment(memos)
        .safeAreaInset(edge: .top) {
            if notifications.deferred {
                Button { notifications.openPending() } label: {
                    Text("알림 대상 열기").padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, minHeight: 44).contentShape(Rectangle())
                }
                .background(DesignTokens.surface, ignoresSafeAreaEdges: [])
                .accessibilityIdentifier("notifications.openDeferred")
            }
        }
        .onChange(of: notifications.route?.id, initial: true) {
            guard let route = notifications.route else { return }
            if route.ticket.isPlanning {
                recordsRequest = RecordsNotificationRequest(week: LocalDate(.now).monday)
                selection = .records
                notifications.dismissRoute()
            } else { selection = .today }
        }
        .onChange(of: selection) { previous, _ in
            if previous == .records { memos.flushAll(in: context) }
        }
        .onChange(of: scenePhase) {
            if scenePhase != .active { memos.flushAll(in: context) }
            else { notifications.requestReconcile() }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in notifications.requestReconcile() }
        .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in notifications.requestReconcile() }
    }
}
