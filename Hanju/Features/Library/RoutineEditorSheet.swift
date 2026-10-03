import SwiftData
import SwiftUI

struct RoutineEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var draft = RoutineDraft()
    @State private var errorMessage: String?
    @State private var showDiscardConfirmation = false
    @State private var hasSaved = false
    @FocusState private var nameFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("이름") {
                    TextField("예: 책상 정리", text: $draft.name, axis: .vertical)
                        .focused($nameFocused)
                        .accessibilityLabel("루틴 이름")
                        .submitLabel(.done)
                    if let errorMessage {
                        Label(errorMessage, systemImage: "exclamationmark.circle")
                            .font(.callout)
                            .accessibilityFocused($errorFocused)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(DesignTokens.background)
            .navigationTitle("새 루틴")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소", action: cancel)
                        .confirmationDialog("변경한 내용을 버릴까요?", isPresented: $showDiscardConfirmation, titleVisibility: .visible) {
                            Button("변경 버리기", role: .destructive) { dismiss() }
                            Button("계속 편집", role: .cancel) { }
                        }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장", action: save)
                        .disabled(hasSaved)
                }
            }
        }
        .interactiveDismissDisabled(draft.hasChanges)
        .onAppear { nameFocused = true }
    }

    private func cancel() {
        if draft.hasChanges {
            showDiscardConfirmation = true
        } else {
            dismiss()
        }
    }

    private func save() {
        guard !hasSaved else { return }
        do {
            try RoutineWriter.create(from: draft, in: context)
            hasSaved = true
            dismiss()
        } catch let error as RoutineDraft.ValidationError {
            errorMessage = error.localizedDescription
            nameFocused = true
            errorFocused = true
        } catch {
            errorMessage = "저장하지 못했어요. 입력한 내용은 그대로예요. 다시 저장해주세요."
            errorFocused = true
        }
    }
}
