import SwiftData
import SwiftUI

struct RecordsView: View {
    @Environment(NotificationCoordinator.self) private var notifications
    @Binding var notificationRequest: RecordsNotificationRequest?
    let openWeek: (LocalDate) -> Void
    let planNextWeek: (LocalDate) -> Void
    @Environment(\.modelContext) private var context
    @Environment(ExecutionRecorder.self) private var recorder
    @Environment(WeeklyMemoCoordinator.self) private var memos
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var week = LocalDate(.now).monday
    @State private var today = LocalDate(.now)
    @State private var snapshot: WeeklyRecordsSnapshot?
    @State private var error: String?
    @State private var editing: ExecutionSnapshot?
    @State private var editedID: UUID?
    @FocusState private var memoFocused: Bool
    @AccessibilityFocusState private var focused: Focus?
    @ScaledMetric(relativeTo: .body) private var memoHeight = 160.0
    private enum Focus: Hashable { case week, row(UUID) }
    private var current: WeeklyRecordsSnapshot? { snapshot?.week == week ? snapshot : nil }
    private var nextWeek: LocalDate { today.monday.adding(days: 7) }
    private var memo: WeeklyMemoCoordinator.Draft { memos.draft(for: week) }
    private var memoBinding: Binding<String> {
        Binding(get: { memos.draft(for: week).body }, set: { memos.update(body: $0, week: week, in: context) })
    }

    var body: some View {
        List {
            Section {
                Text("\(week.fullLabel) – \(week.adding(days: 6).label)").font(.headline)
                    .accessibilityIdentifier("records.range").accessibilityFocused($focused, equals: .week)
                let navigationLayout = dynamicTypeSize.isAccessibilitySize
                    ? AnyLayout(VStackLayout(alignment: .leading, spacing: DesignTokens.spacing))
                    : AnyLayout(HStackLayout())
                navigationLayout {
                    Button("지난주", systemImage: "chevron.left") { changeWeek(week.adding(days: -7)) }
                        .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil, alignment: .leading)
                    if !dynamicTypeSize.isAccessibilitySize { Spacer() }
                    Button("이번 주") { changeWeek(today.monday) }
                        .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil, alignment: .leading)
                    if !dynamicTypeSize.isAccessibilitySize { Spacer() }
                    Button("다음 주", systemImage: "chevron.right") { changeWeek(week.adding(days: 7)) }
                        .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil, alignment: .leading)
                }
                .buttonStyle(.borderless)
            }
            if let error { Section { Text(error); Button("다시 불러오기", action: load) } }
            if let current {
                if current.completed.isEmpty {
                    Section { Text("아직 남긴 기록이 없어요.").foregroundStyle(DesignTokens.textSecondary) }
                }
                ForEach(week.weekDays) { day in
                    let rows = current.completed.filter { $0.performedOn == day }
                    if !rows.isEmpty {
                        Section {
                            ForEach(rows) { record in
                                Button { edit(record.id) } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Label(record.occurrence.name, systemImage: "checkmark").font(.headline)
                                        Text(record.duration(at: recorder.now()).label).font(.subheadline)
                                            .foregroundStyle(DesignTokens.textSecondary)
                                        if current.movedOccurrenceIDs.contains(record.id) {
                                            Text("날짜를 옮겨 마침").font(.footnote).foregroundStyle(DesignTokens.textSecondary)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain).accessibilityIdentifier("records.row.\(record.id)")
                                .accessibilityHint("실행 기록 편집").accessibilityFocused($focused, equals: .row(record.id))
                            }
                        } header: { recordsHeader(day.fullLabel) }
                    }
                }
                if !current.routineCounts.isEmpty {
                    Section {
                        ForEach(current.routineCounts) { count in
                            LabeledContent(count.name, value: "\(count.count)회")
                                .accessibilityIdentifier("records.count.\(count.id)")
                        }
                    } header: { recordsHeader("루틴별 실천 횟수") }
                }
                if current.timeSummary.totalSeconds != nil || current.timeSummary.sumOverflow {
                    Section {
                        if current.timeSummary.sumOverflow {
                            Text("시간 합계가 표시 범위를 넘었어요.")
                        } else if let seconds = current.timeSummary.totalSeconds {
                            Text("합계 · \(RecordedDuration.format(seconds))").accessibilityIdentifier("records.totalTime")
                        }
                        if current.timeSummary.unrecordedCount > 0 {
                            Text("시간 미기록 \(current.timeSummary.unrecordedCount)건").font(.subheadline)
                        }
                        if current.timeSummary.needsReviewCount > 0 {
                            Text("시간 확인 필요 \(current.timeSummary.needsReviewCount)건은 합계에 포함하지 않았어요.").font(.subheadline)
                        }
                    } header: { recordsHeader("기록한 시간") }
                }
            }
            Section {
                Text("이번 주에 기억해두고 싶은 게 있나요?").foregroundStyle(DesignTokens.textSecondary)
                TextEditor(text: memoBinding).frame(minHeight: memoHeight).focused($memoFocused)
                    .disabled(!memo.isLoaded).accessibilityLabel("주간 메모").accessibilityIdentifier("records.memo")
                memoStatus
            } header: { recordsHeader("주간 메모") }
            Section {
                Button("지난 계획 보기") { leaveForPlan { openWeek(week) } }
                Button { leaveForPlan { planNextWeek(nextWeek) } } label: {
                    VStack(alignment: .leading) {
                        Text("다음 주 계획하기")
                        Text("\(nextWeek.fullLabel) – \(nextWeek.adding(days: 6).label)").font(.subheadline)
                    }
                }
                .accessibilityIdentifier("records.planNextWeek")
            }
        }
        .listStyle(.plain).scrollContentBackground(.hidden).background(DesignTokens.background)
        .navigationTitle("기록")
        .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("입력 완료") { memoFocused = false } } }
        .sheet(item: $editing, onDismiss: didDismiss) { CompletionSheet(source: $0) }
        .notificationPresentation(owner: "records", blocked: editing != nil || memoFocused)
        .onAppear { notifications.setPlanningVisible(true); refreshClock(); load(); consumeNotificationRequest() }
        .onChange(of: notificationRequest) { consumeNotificationRequest() }
        .onDisappear { notifications.setPlanningVisible(false); memos.flush(week: week, in: context) }
        .onChange(of: memoFocused) { if !memoFocused { memos.flush(week: week, in: context) } }
        .onChange(of: recorder.revision) { load() }
        .onChange(of: scenePhase) {
            if scenePhase == .active { refreshClock(); load() }
            else { memos.flush(week: week, in: context) }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in refreshClock() }
        .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in refreshClock() }
    }

    private func recordsHeader(_ title: String) -> some View {
        Text(title).font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, DesignTokens.spacing)
            .padding(.bottom, DesignTokens.spacing / 2)
            .background(DesignTokens.background)
            .listRowInsets(EdgeInsets())
    }

    @ViewBuilder private var memoStatus: some View {
        switch memo.status {
        case .idle: EmptyView()
        case .pending, .saving: Text("저장 중…").font(.footnote).foregroundStyle(DesignTokens.textSecondary)
        case .saved: Text("저장됨").font(.footnote).foregroundStyle(DesignTokens.textSecondary)
        case .failed(let message):
            Text(message).font(.footnote)
            Button(memo.isDirty ? "다시 저장" : "메모 다시 불러오기") { memos.retry(week: week, in: context) }
        }
    }
    private func changeWeek(_ destination: LocalDate) {
        memos.flush(week: week, in: context); memoFocused = false
        week = destination.monday; load(); focused = .week
    }
    private func leaveForPlan(_ action: () -> Void) {
        memos.flush(week: week, in: context); memoFocused = false; action()
    }
    private func refreshClock() { today = LocalDate(recorder.now().wall) }
    private func consumeNotificationRequest() {
        guard editing == nil, !memoFocused, let request = notificationRequest else { return }
        memos.flush(week: week, in: context)
        week = request.week; notificationRequest = nil; load()
    }
    private func load() {
        do { snapshot = try RecordsStore.fetch(week: week, in: context, at: recorder.now()); error = nil }
        catch { self.error = "기록을 불러오지 못했어요. \(error.localizedDescription)" }
        memos.load(week: week, in: context)
    }
    private func edit(_ id: UUID) {
        do {
            let source = try recorder.read(id)
            guard source.occurrence.status == .completed else { throw ExecutionError.changed }
            memos.flush(week: week, in: context); memoFocused = false
            editedID = id; editing = source
        } catch { self.error = error.localizedDescription }
    }
    private func didDismiss() {
        load()
        if let editedID, current?.completed.contains(where: { $0.id == editedID }) == true { focused = .row(editedID) }
        else { focused = .week }
    }
}
