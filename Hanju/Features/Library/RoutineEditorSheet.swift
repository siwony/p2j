import SwiftData
import SwiftUI

struct RoutineEditorSheet: View {
    private enum PendingAction { case dismiss, archive }
    private enum RecoveryAction { case save, archive }
    let onSaved: (UUID) -> Void
    private let original: RoutineSnapshot?
    private let initialDraft: RoutineDraft
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var draft: RoutineDraft
    @State private var errorMessage: String?
    @State private var invalidField: RoutineDraft.Field?
    @State private var storageError = ""
    @State private var showStorageError = false
    @State private var recoveryAction: RecoveryAction = .save
    @State private var showDiscardConfirmation = false
    @State private var pendingAction: PendingAction = .dismiss
    @State private var hasCommitted = false
    @State private var returnField: RoutineDraft.Field? = .name
    @FocusState private var focusedField: RoutineDraft.Field?
    @AccessibilityFocusState private var errorFocused: Bool

    init(id: UUID, routine: RoutineSnapshot?, onSaved: @escaping (UUID) -> Void = { _ in }) {
        self.onSaved = onSaved
        original = routine
        let draft = routine?.draft ?? RoutineDraft(id: id)
        initialDraft = draft
        _draft = State(initialValue: draft)
    }

    private var isDirty: Bool { draft != initialDraft }

    var body: some View {
        NavigationStack {
            Form {
                Section("이름") {
                    TextField("예: 책상 정리", text: $draft.name, axis: .vertical)
                        .focused($focusedField, equals: .name)
                        .accessibilityLabel("루틴 이름")
                        .accessibilityIdentifier("routine.name")
                    if invalidField == .name, let errorMessage {
                        RoutineFieldError(message: errorMessage).accessibilityFocused($errorFocused)
                    }
                }
                Section("기본 정보") {
                    Picker("분류", selection: $draft.category) {
                        Text("분류 없음").tag(String?.none)
                        ForEach(RoutineDraft.categories, id: \.self) { Text($0).tag(Optional($0)) }
                        if let category = draft.category, !RoutineDraft.categories.contains(category) {
                            Text(category).tag(Optional(category))
                        }
                    }
                    .accessibilityIdentifier("routine.category")
                    LabeledContent("예상 시간 (분)") {
                        TextField("미정", text: $draft.expectedMinutesText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .expectedMinutes)
                            .accessibilityLabel("예상 시간, 분, 선택")
                            .accessibilityIdentifier("routine.expectedMinutes")
                    }
                    if invalidField == .expectedMinutes, let errorMessage {
                        RoutineFieldError(message: errorMessage).accessibilityFocused($errorFocused)
                    }
                }
                Section {
                    LabeledContent("주간 기본 횟수") {
                        TextField("미정", text: $draft.weeklyFrequencyText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .weeklyFrequency)
                            .accessibilityLabel("주간 기본 횟수, 선택")
                            .accessibilityIdentifier("routine.weeklyFrequency")
                    }
                    if invalidField == .weeklyFrequency, let errorMessage {
                        RoutineFieldError(message: errorMessage).accessibilityFocused($errorFocused)
                    }
                    DisclosureGroup("선호 요일 (선택)") {
                        ForEach(1...7, id: \.self) { day in
                            Button { toggleDay(day) } label: {
                                HStack {
                                    Text(dayName(day))
                                    Spacer()
                                    if draft.preferredWeekdays.contains(day) { Image(systemName: "checkmark") }
                                }
                            }
                            .foregroundStyle(DesignTokens.textPrimary)
                            .accessibilityValue(draft.preferredWeekdays.contains(day) ? "선택됨" : "선택 안 됨")
                            .accessibilityIdentifier("routine.weekday.\(day)")
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("시작 행동 (선택)").font(.subheadline)
                        TextField("예: 문제집 펼치기", text: $draft.firstAction, axis: .vertical)
                            .focused($focusedField, equals: .firstAction)
                            .accessibilityLabel("시작 행동")
                            .accessibilityIdentifier("routine.firstAction")
                    }
                    VStack(alignment: .leading) {
                        Text("메모 (선택)").font(.subheadline)
                        TextField("자유롭게 적어두세요", text: $draft.note, axis: .vertical)
                            .focused($focusedField, equals: .note)
                            .accessibilityLabel("메모")
                            .accessibilityIdentifier("routine.note")
                    }
                } header: { Text("필요하면 더 적기") }
                footer: { Text("이름만 있어도 저장할 수 있어요. 나머지는 비워두어도 괜찮아요.") }
                if let original {
                    Section {
                        Button(original.isArchived ? "복원" : "보관", action: requestArchive)
                    } footer: {
                        Text(original.isArchived ? "복원하면 루틴함에서 다시 고를 수 있어요." : "보관하면 루틴함에서 잠시 숨겨져요. 이전 계획과 기록은 그대로 남아요.")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(DesignTokens.background)
            .navigationTitle(original == nil ? "새 루틴" : "루틴 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소", action: requestDismiss)
                        .confirmationDialog(discardTitle, isPresented: $showDiscardConfirmation, titleVisibility: .visible) {
                            Button(discardActionTitle, role: .destructive, action: discard)
                            // Native popovers can omit cancel-role actions.
                            Button("계속 편집", action: keepEditing)
                        }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장", action: save).disabled(hasCommitted)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("입력 완료") { focusedField = nil }
                }
            }
        }
        .interactiveDismissDisabled(isDirty)
        .background(UnsavedChangesGuard(isDirty: isDirty, onAttempt: requestDismiss))
        .alert("변경하지 못했어요", isPresented: $showStorageError) {
            Button(recoveryAction == .save ? "다시 저장" : "다시 시도") {
                if recoveryAction == .save { save() } else { archive() }
            }
            Button("계속 편집", role: .cancel) { focusedField = returnField }
        } message: { Text(storageError) }
        .onAppear { if original == nil { focusedField = .name } }
    }

    private var discardTitle: String {
        pendingAction == .dismiss ? "변경한 내용을 버릴까요?" : "변경한 내용을 저장하지 않고 \(original?.isArchived == true ? "복원" : "보관")할까요?"
    }
    private var discardActionTitle: String {
        pendingAction == .dismiss ? "변경 버리기" : "변경 버리고 \(original?.isArchived == true ? "복원" : "보관")"
    }
    private func requestDismiss() {
        pendingAction = .dismiss
        if isDirty { confirmDiscard() } else { dismiss() }
    }
    private func requestArchive() {
        pendingAction = .archive
        if isDirty { confirmDiscard() } else { archive() }
    }
    private func confirmDiscard() {
        returnField = focusedField
        showDiscardConfirmation = true
    }
    private func keepEditing() {
        showDiscardConfirmation = false
        focusedField = returnField
    }
    private func discard() {
        if pendingAction == .dismiss { dismiss() } else { archive() }
    }
    private func toggleDay(_ day: Int) {
        if draft.preferredWeekdays.contains(day) { draft.preferredWeekdays.remove(day) }
        else { draft.preferredWeekdays.insert(day) }
    }
    private func dayName(_ day: Int) -> String {
        ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"][day - 1]
    }
    private func archive() {
        guard !hasCommitted, let original else { return }
        do {
            try RoutineWriter.setArchived(!original.isArchived, id: original.id, in: context)
            hasCommitted = true
            dismiss()
        } catch {
            recoveryAction = .archive
            storageError = "루틴과 입력한 내용은 그대로예요. \(original.isArchived ? "복원" : "보관")을 다시 시도할 수 있어요."
            showStorageError = true
        }
    }
    private func save() {
        guard !hasCommitted else { return }
        do {
            try RoutineWriter.persist(draft, updating: original != nil, in: context)
            onSaved(draft.id)
            hasCommitted = true
            dismiss()
        } catch let error as RoutineDraft.ValidationError {
            errorMessage = error.localizedDescription
            invalidField = error.field
            focusedField = error.field
            errorFocused = true
        } catch {
            recoveryAction = .save
            storageError = (error as? RoutineWriter.WriteError)?.localizedDescription ?? "입력한 내용은 그대로예요. 다시 저장해주세요."
            showStorageError = true
        }
    }
}
