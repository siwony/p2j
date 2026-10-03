import SwiftData
import SwiftUI

struct RoutineListView: View {
    let archived: Bool

    private struct Editor: Identifiable {
        let id: UUID
        let routine: RoutineSnapshot?
    }
    private enum Focus: Hashable { case newRoutine, routine(UUID), archive, filter, empty }

    @Environment(\.modelContext) private var context
    @State private var routines: [RoutineSnapshot] = []
    @State private var editor: Editor?
    @State private var loadFailed = false
    @State private var actionError: String?
    @State private var filter = "전체"
    @State private var returnFocus: Focus?
    @State private var savedID: UUID?
    @AccessibilityFocusState private var focused: Focus?

    var body: some View {
        ScrollViewReader { proxy in
            List {
                if loadFailed {
                    Section {
                        Text("루틴을 불러오지 못했어요.")
                        Button("다시 시도", systemImage: "arrow.clockwise", action: load)
                    }
                }
                if !routines.isEmpty {
                    Section {
                        Picker("분류", selection: $filter) {
                            Text("전체").tag("전체")
                            ForEach(categories, id: \.self) { Text($0).tag($0) }
                        }
                        .accessibilityIdentifier("routine.categoryFilter")
                        .accessibilityFocused($focused, equals: .filter)
                    }
                }
                if routines.isEmpty && !loadFailed {
                    Section {
                        Text(archived ? "보관한 루틴이 없어요." : "반복하고 싶은 일을 하나 적어보세요.")
                            .foregroundStyle(DesignTokens.textSecondary)
                            .accessibilityFocused($focused, equals: .empty)
                        if !archived {
                            Button("루틴 만들기", systemImage: "plus", action: create)
                        }
                    }
                }
                ForEach(visibleCategories, id: \.self) { category in
                    Section(category) {
                        ForEach(routines.filter { ($0.draft.category ?? "분류 없음") == category }) { routine in
                            Button { edit(routine) } label: { RoutineRow(routine: routine) }
                                .id(routine.id)
                                .accessibilityIdentifier("routine.row.\(routine.id)")
                                .accessibilityFocused($focused, equals: .routine(routine.id))
                                .contextMenu {
                                    Button(archived ? "복원" : "보관", systemImage: archived ? "arrow.uturn.backward" : "archivebox") {
                                        changeArchive(routine)
                                    }
                                }
                                .listRowBackground(DesignTokens.surface)
                        }
                    }
                }
                if !archived {
                    Section {
                        NavigationLink("보관함", value: LibraryView.Destination.archive)
                            .accessibilityFocused($focused, equals: .archive)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(DesignTokens.background)
            .navigationTitle(archived ? "보관함" : "루틴함")
            .toolbar {
                if !archived {
                    ToolbarItem(placement: .primaryAction) {
                        Button("새 루틴", systemImage: "plus", action: create)
                            .accessibilityFocused($focused, equals: .newRoutine)
                    }
                }
            }
            .sheet(item: $editor, onDismiss: didDismiss) { item in
                RoutineEditorSheet(id: item.id, routine: item.routine) { savedID = $0 }
            }
            .alert("변경하지 못했어요", isPresented: errorPresented) {
                Button("확인", role: .cancel) { actionError = nil }
            } message: { Text(actionError ?? "") }
            .task { load() }
            .onChange(of: routines) {
                if let savedID {
                    proxy.scrollTo(savedID, anchor: .center)
                    focused = .routine(savedID)
                    self.savedID = nil
                }
            }
        }
    }

    private var errorPresented: Binding<Bool> {
        Binding(get: { actionError != nil }, set: { if !$0 { actionError = nil } })
    }

    private var categories: [String] {
        let all = Set(routines.map { $0.draft.category ?? "분류 없음" })
        return (RoutineDraft.categories + ["분류 없음"]).filter(all.contains)
            + all.subtracting(RoutineDraft.categories + ["분류 없음"]).sorted()
    }

    private var visibleCategories: [String] {
        filter == "전체" ? categories : categories.filter { $0 == filter }
    }

    private func create() {
        savedID = nil
        returnFocus = .newRoutine
        // Allocate once for this editing command, never during view rendering.
        let commandID = UUID()
        editor = Editor(id: commandID, routine: nil)
    }

    private func edit(_ routine: RoutineSnapshot) {
        savedID = nil
        returnFocus = .routine(routine.id)
        editor = Editor(id: routine.id, routine: routine)
    }

    private func didDismiss() {
        load()
        if let savedID, let saved = routines.first(where: { $0.id == savedID }) {
            let category = saved.draft.category ?? "분류 없음"
            if filter != "전체", filter != category { filter = category }
            returnFocus = .routine(savedID)
        }
        if case .routine(let id) = returnFocus {
            let visible = routines.contains { $0.id == id && (filter == "전체" || ($0.draft.category ?? "분류 없음") == filter) }
            if !visible { returnFocus = routines.isEmpty ? (archived ? .empty : .newRoutine) : .filter }
        }
        if savedID == nil { focused = returnFocus }
    }

    private func changeArchive(_ routine: RoutineSnapshot) {
        do {
            try RoutineWriter.setArchived(!archived, id: routine.id, in: context)
            load()
            focused = routines.isEmpty ? (archived ? .empty : .newRoutine) : .filter
        } catch {
            actionError = "루틴은 그대로예요. 다시 시도해주세요."
        }
    }

    private func load() {
        do {
            routines = try RoutineWriter.fetch(in: context, archived: archived)
            if filter != "전체", !categories.contains(filter) { filter = "전체" }
            loadFailed = false
        } catch { loadFailed = true }
    }
}
