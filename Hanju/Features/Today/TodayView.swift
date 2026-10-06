import SwiftData
import SwiftUI

struct TodayView: View {
    let openWeek: (LocalDate) -> Void
    let plan: (LocalDate) -> Void
    let recover: (LocalDate) -> Void
    let openLibrary: () -> Void
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    @State private var today = LocalDate(.now)
    @State private var rows: [OccurrenceSnapshot] = []
    @State private var error: String?

    var body: some View {
        List {
            Section { Text(today.fullLabel).font(.headline) }
            if let error { Section { Text(error); Button("다시 시도", action: load) } }
            Section {
                let scheduled = rows.filter { $0.day == today && $0.status != .skipped }
                if scheduled.isEmpty { Text("오늘은 정해둔 일이 없어요.").font(.title2) }
                ForEach(scheduled) { row in
                    VStack(alignment: .leading) {
                        Text(row.name).font(.headline)
                        Text([row.time?.label, row.expectedMinutes.map { "예상 \($0)분" }, row.statusLabel].compactMap { $0 }.joined(separator: " · "))
                            .font(.subheadline).foregroundStyle(DesignTokens.textSecondary)
                        if let firstAction = row.firstAction { Text(firstAction).font(.subheadline) }
                    }
                }
                Button("이번 주 보기") { openWeek(today) }
                if rows.isEmpty { Button("남은 이번 주 계획하기") { plan(today) } }
                Button("루틴 만들러 가기", action: openLibrary)
            }
            if rows.contains(where: { $0.day < today && $0.canReplan }) {
                Section { Button("이번 주 계획 다시 고르기") { recover(today) } }
            }
            if today.weekday == 7 {
                Section { Button("다음 주 계획하기") { plan(today.adding(days: 1)) } }
            }
        }
        .listStyle(.plain).scrollContentBackground(.hidden).background(DesignTokens.background)
        .navigationTitle("오늘")
        .onAppear(perform: load)
        .onChange(of: scenePhase) { if scenePhase == .active { load() } }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in load() }
        .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in load() }
    }
    private func load() {
        today = LocalDate(.now)
        do { rows = try PlanWriter.fetch(week: today.monday, in: context); error = nil }
        catch { self.error = error.localizedDescription }
    }
}
