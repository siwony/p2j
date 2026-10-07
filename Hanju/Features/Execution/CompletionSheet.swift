import SwiftUI

struct CompletionSheet: View {
    let source: ExecutionSnapshot
    @Environment(ExecutionRecorder.self) private var recorder
    @Environment(\.dismiss) private var dismiss
    @State private var draft: CompletionDraft
    @State private var confirming = false
    @State private var error: String?
    @State private var undoConfirmation = false
    @State private var returnToMinutes = false
    @FocusState private var minutesFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool
    init(source: ExecutionSnapshot) { self.source = source; _draft = State(initialValue: CompletionDraft(source)) }
    private var dirty: Bool { draft != CompletionDraft(source) }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(source.occurrence.name).font(.headline)
                    Label("완료했어요", systemImage: "checkmark")
                    Text("계획한 날짜 · \(source.occurrence.day.fullLabel)").font(.subheadline)
                }
                Section("실제로 한 날짜") {
                    DatePicker("수행일", selection: dateBinding, in: ...LocalDate(.now).pickerDate, displayedComponents: .date)
                        .environment(\.calendar, LocalDate.calendar(in: .gmt)).environment(\.timeZone, .gmt)
                    Text("완료를 입력한 날짜와 측정 구간은 그대로 남아요.").font(.footnote)
                }
                Section("기록한 시간") {
                    Text(source.duration(at: recorder.now()).label).accessibilityIdentifier("execution.duration")
                    LabeledContent("실제 시간 (분)") {
                        TextField("선택 사항", text: $draft.minutes).keyboardType(.decimalPad)
                            .focused($minutesFocused).accessibilityLabel("실제 시간 (분)")
                            .accessibilityIdentifier("execution.minutes")
                    }
                    Text("비우면 원래 측정 시간으로 돌아가요. 측정한 시간이 없으면 시간 미기록으로 남아요.").font(.footnote)
                    if source.duration(at: recorder.now()).needsReview {
                        Text("기기 시간이 바뀌어 일부 구간을 확인할 수 없어요. 시간을 입력하지 않고 날짜만 저장해도 돼요.").font(.footnote)
                    }
                }
                if let error { Section { Text(error).accessibilityFocused($errorFocused) } }
                Section {
                    Button("완료 취소") { undoConfirmation = true }
                        .confirmationDialog("완료 표시를 취소할까요?", isPresented: $undoConfirmation, titleVisibility: .visible) {
                            Button("완료 취소", role: .destructive, action: undo)
                            Button("계속 두기", role: .cancel) {}
                        } message: { Text("측정한 구간과 시간은 남아요. 편집 중인 내용은 버려요.") }
                }
            }
            .scrollContentBackground(.hidden).background(DesignTokens.background)
            .navigationTitle("실행 기록").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("취소") { if dirty { confirming = true } else { dismiss() } } }
                ToolbarItem(placement: .confirmationAction) { Button("저장", action: save) }
                ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("입력 완료") { minutesFocused = false } }
            }
            .modifier(PlanDismissal(dirty: dirty, onDiscard: { dismiss() }, confirming: $confirming))
            .onChange(of: confirming) {
                if confirming { returnToMinutes = minutesFocused }
                else if returnToMinutes { minutesFocused = true }
            }
        }
    }
    private var dateBinding: Binding<Date> {
        Binding(get: { draft.performedOn.pickerDate }, set: { draft.performedOn = LocalDate($0, timeZone: .gmt) })
    }
    private func save() {
        do { try recorder.edit(source, draft: draft); dismiss() }
        catch { self.error = error.localizedDescription; errorFocused = true }
    }
    private func undo() {
        do { try recorder.undo(source); dismiss() }
        catch { self.error = error.localizedDescription; errorFocused = true }
    }
}
