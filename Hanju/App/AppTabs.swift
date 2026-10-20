import SwiftData
import SwiftUI

struct AppTabs: View {
    private enum Tab: Hashable {
        case today, week, library, records, settings
    }

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
                RecordsView(openWeek: { day in
                    weekRequest = WeekRequest(kind: .agenda, day: day, caller: .records); selection = .week
                }, planNextWeek: { day in
                    weekRequest = WeekRequest(kind: .plan, day: day, caller: .records); selection = .week
                })
            }
            .tabItem { Label("기록", systemImage: "text.book.closed") }
            .tag(Tab.records)

            NavigationStack {
                Form {
                    Section("데이터 저장") {
                        Text("계획과 실행 기록은 이 iPhone에 저장돼요.")
                        Text("앱을 삭제하면 저장된 데이터도 지워져요.")
                            .foregroundStyle(DesignTokens.textSecondary)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(DesignTokens.background)
                .navigationTitle("설정")
            }
            .tabItem { Label("설정", systemImage: "gearshape") }
            .tag(Tab.settings)
        }
        .environment(memos)
        .onChange(of: selection) { previous, _ in
            if previous == .records { memos.flushAll(in: context) }
        }
        .onChange(of: scenePhase) { if scenePhase != .active { memos.flushAll(in: context) } }
    }
}
