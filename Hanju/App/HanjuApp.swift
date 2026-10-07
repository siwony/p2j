import SwiftUI

@main
@MainActor
struct HanjuApp: App {
    @State private var persistence = PersistenceStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if let container = persistence.container, let recorder = persistence.recorder {
                    AppTabs()
                        .modelContainer(container)
                        .environment(recorder)
                } else if let message = persistence.failureMessage {
                    ContentUnavailableView {
                        Label("데이터를 열지 못했어요", systemImage: "externaldrive.badge.exclamationmark")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("다시 시도", systemImage: "arrow.clockwise") {
                            persistence.open()
                        }
                        .buttonStyle(.borderedProminent).foregroundStyle(DesignTokens.onAccent)
                    }
                } else {
                    ProgressView("데이터 여는 중")
                }
            }
            .tint(DesignTokens.accent)
            .foregroundStyle(DesignTokens.textPrimary)
            .background(DesignTokens.background)
            .task { persistence.open() }
        }
    }
}
