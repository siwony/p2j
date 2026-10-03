import SwiftUI

struct AppTabs: View {
    private enum Tab: Hashable {
        case today, week, library, records, settings
    }

    @State private var selection: Tab = .today

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                emptyScreen(title: "오늘", message: "오늘은 정해둔 일이 없어요.") {
                    Button("이번 주 보기") { selection = .week }
                    Button("루틴 만들러 가기") { selection = .library }
                }
            }
            .tabItem { Label("오늘", systemImage: "sun.max") }
            .tag(Tab.today)

            NavigationStack {
                emptyScreen(title: "이번 주", message: "반복하고 싶은 일을 먼저 적어보세요.") {
                    Button("루틴함 보기") { selection = .library }
                }
            }
            .tabItem { Label("이번 주", systemImage: "calendar") }
            .tag(Tab.week)

            NavigationStack { LibraryView() }
                .tabItem { Label("루틴함", systemImage: "square.stack") }
                .tag(Tab.library)

            NavigationStack {
                emptyScreen(title: "기록", message: "아직 남긴 기록이 없어요.") {
                    EmptyView()
                }
            }
            .tabItem { Label("기록", systemImage: "text.book.closed") }
            .tag(Tab.records)

            NavigationStack {
                Form {
                    Section("데이터 저장") {
                        Text("루틴은 이 iPhone에 저장돼요.")
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
    }

    private func emptyScreen<Actions: View>(
        title: String, message: String, @ViewBuilder actions: () -> Actions
    ) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacing) {
                Text(message)
                    .font(.title2)
                actions()
                    .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignTokens.screenInset)
        }
        .background(DesignTokens.background)
        .navigationTitle(title)
    }
}
