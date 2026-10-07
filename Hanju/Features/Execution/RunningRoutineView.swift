import SwiftUI

struct RunningRoutineView: View {
    let occurrenceID: UUID
    @Environment(ExecutionRecorder.self) private var recorder
    @Environment(\.dismiss) private var dismiss
    @State private var source: ExecutionSnapshot?
    @State private var error: String?
    @State private var replacing: ExecutionSnapshot?
    @State private var confirmSwitch = false
    @ScaledMetric(relativeTo: .largeTitle) private var displaySize = DesignTokens.timerSize
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacing) {
                if let source {
                    Text(source.occurrence.name).font(.title)
                    if let first = source.occurrence.firstAction { Text(first).font(.title2) }
                    Text(source.occurrence.statusLabel)
                    TimelineView(.periodic(from: .now, by: 1)) { _ in
                        let duration = source.duration(at: recorder.now())
                        Text(duration.seconds.map { RecordedDuration.timerLabel($0) } ?? duration.label)
                            .font(.system(size: displaySize).monospacedDigit())
                            .accessibilityLabel("기록 시간").accessibilityValue(duration.label)
                            .accessibilityIdentifier("execution.timer")
                    }
                    if source.duration(at: recorder.now()).needsReview {
                        Text("일부 구간의 시간을 확인할 수 없어요. 완료 후 필요하면 시간을 수정할 수 있어요.")
                    }
                    if source.occurrence.status == .running {
                        Button("일시정지") { perform { try recorder.pause(source) } }.buttonStyle(.bordered)
                    } else if source.occurrence.canReplan {
                        Button("이어서 하기", action: resume).buttonStyle(.bordered)
                    }
                    if source.occurrence.isUnfinished {
                        Button("완료", systemImage: "checkmark") { perform { try recorder.complete(source); dismiss() } }
                            .buttonStyle(.borderedProminent).foregroundStyle(DesignTokens.onAccent)
                    }
                    Text("계획한 날짜 · \(source.occurrence.day.fullLabel)").font(.subheadline)
                    if let minutes = source.occurrence.expectedMinutes { Text("예상 \(minutes)분").font(.subheadline) }
                } else { Text("시작할 일을 골라보세요.") }
                if let error = error ?? recorder.failure { Text(error); Button("다시 불러오기") { recorder.refresh(); load() } }
                Button("오늘로 돌아가기") { dismiss() }
            }.frame(maxWidth: .infinity, alignment: .leading).padding(DesignTokens.screenInset)
        }
        .background(DesignTokens.background).navigationTitle("실행 중").navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: load).onChange(of: recorder.revision) { load() }
        .confirmationDialog("하던 일을 일시정지하고 시작할까요?", isPresented: $confirmSwitch, titleVisibility: .visible) {
            Button("일시정지하고 시작") {
                guard let source else { return }; perform { try recorder.start(source, replacing: replacing) }
            }
            Button("취소", role: .cancel) {}
        } message: { if let replacing { Text(replacing.occurrence.name) } }
    }
    private func load() { do { source = try recorder.read(occurrenceID); error = nil } catch { self.error = error.localizedDescription } }
    private func resume() {
        guard let source else { return }
        if let active = recorder.active, active.id != source.id { replacing = active; confirmSwitch = true }
        else { perform { try recorder.start(source) } }
    }
    private func perform(_ action: () throws -> Void) { do { try action(); load() } catch { self.error = error.localizedDescription } }
}
