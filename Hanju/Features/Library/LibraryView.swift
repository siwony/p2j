import SwiftData
import SwiftUI

struct LibraryView: View {
    private enum Sheet: String, Identifiable {
        case newRoutine
        var id: String { rawValue }
    }

    @Environment(\.modelContext) private var context
    @State private var routines: [RoutineTemplate] = []
    @State private var sheet: Sheet?
    @State private var loadFailed = false

    var body: some View {
        List {
            if loadFailed {
                Section {
                    Text("루틴을 불러오지 못했어요.")
                    Button("다시 시도", systemImage: "arrow.clockwise", action: load)
                }
            }
            if routines.isEmpty && !loadFailed {
                Section {
                    Text("반복하고 싶은 일을 하나 적어보세요.")
                        .foregroundStyle(DesignTokens.textSecondary)
                    Button("루틴 만들기", systemImage: "plus") { sheet = .newRoutine }
                }
            } else {
                ForEach(routines) { routine in
                    Text(routine.name)
                        .font(.body)
                        .padding(.vertical, 4)
                        .listRowBackground(DesignTokens.surface)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(DesignTokens.background)
        .navigationTitle("루틴함")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("새 루틴", systemImage: "plus") { sheet = .newRoutine }
            }
        }
        .sheet(item: $sheet, onDismiss: load) { _ in
            RoutineEditorSheet()
        }
        .task { load() }
    }

    private func load() {
        do {
            let request = FetchDescriptor<RoutineTemplate>(
                predicate: #Predicate { !$0.isArchived },
                sortBy: [SortDescriptor(\.createdAt)]
            )
            routines = try context.fetch(request)
            loadFailed = false
        } catch {
            loadFailed = true
        }
    }
}
