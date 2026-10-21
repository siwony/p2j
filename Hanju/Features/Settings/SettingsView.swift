import SwiftUI

struct SettingsView: View {
    @Environment(NotificationCoordinator.self) private var notifications
    @Environment(\.openURL) private var openURL
    @State private var proposed: NotificationPreferences?
    @State private var explain = false
    @State private var choosingTime = false
    @State private var selectedTime = Date.now
    @State private var busy = false

    var body: some View {
        Form {
            Section {
                Toggle("다음 주 계획 알림", isOn: toggle(\.planningEnabled))
                    .accessibilityIdentifier("notifications.planning")
                if notifications.state.preferences.planningEnabled {
                    Picker("요일", selection: value(\.planningWeekday)) {
                        ForEach(1...7, id: \.self) { Text(LocalDate.dayNames[$0 - 1] + "요일").tag($0) }
                    }
                    DatePicker("계획 알림 시각", selection: time(\.planningMinutes), displayedComponents: .hourAndMinute)
                        .environment(\.timeZone, .gmt)
                }
            } header: { Text("계획 알림") } footer: { Text("이번 주 해낸 일과 메모를 보고 다음 주를 골라요. 메모는 비워두어도 괜찮아요.") }
            Section {
                Toggle("정해둔 일 실행 알림", isOn: toggle(\.executionEnabled))
                    .accessibilityIdentifier("notifications.execution")
                if notifications.state.preferences.executionEnabled {
                    Button {
                        let minutes = notifications.state.preferences.executionMinutes
                        selectedTime = minutes.map(pickerDate) ?? pickerDate(Calendar.current.component(.hour, from: .now) * 60 + Calendar.current.component(.minute, from: .now))
                        choosingTime = true
                    } label: {
                        LabeledContent("시각 없는 일정", value: notifications.state.preferences.executionMinutes.flatMap(LocalTime.init(minutes:))?.label ?? "알림 시각 선택")
                    }.accessibilityIdentifier("notifications.defaultTime")
                }
            } header: { Text("실행 알림") } footer: {
                Text("시각을 정한 일은 그 시각에, 시각 없는 일은 선택한 시각에 날짜별로 묶어 알려드려요. 시각을 선택하기 전에는 묶음 알림을 예약하지 않아요.")
            }
            Section("알림 상태") {
                Text(permissionLabel).accessibilityIdentifier("notifications.authorization")
                Text("예약된 알림 \(notifications.scheduledCount)개")
                if notifications.waitingForTime > 0 { Text("시각을 선택하면 알릴 일정 \(notifications.waitingForTime)개 · 예약 대기") }
                if notifications.waitingForCapacity > 0 { Text("예약 대기 \(notifications.waitingForCapacity)건 · 가까운 미래부터 예약하며 앱을 열 때 다시 확인해요.") }
                if notifications.reconciling { ProgressView("예약 확인 중") }
                if let message = notifications.message { Text(message).foregroundStyle(DesignTokens.textSecondary) }
                if notifications.needsRetry || notifications.waitingForCapacity > 0 || !notifications.loaded {
                    Button("다시 시도") { notifications.retry() }.accessibilityIdentifier("notifications.retry")
                }
                if notifications.authorization == .denied {
                    Button("iPhone 설정 열기") { if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) } }
                }
                ForEach(Array(Set(notifications.state.tickets.compactMap(\.explanation))).sorted(), id: \.self) { Text($0).font(.footnote) }
                Text("알림은 이 기기에서 예약해요. 집중 모드와 iPhone 알림 설정에 따라 표시가 달라질 수 있어요.").font(.footnote)
            }
            Section("데이터 저장") {
                Text("계획과 실행 기록은 이 iPhone에 저장돼요.")
                Text("앱을 삭제하면 저장된 데이터도 지워져요.").foregroundStyle(DesignTokens.textSecondary)
            }
        }
        .disabled(busy)
        .scrollContentBackground(.hidden).background(DesignTokens.background).navigationTitle("설정")
        .confirmationDialog("필요한 알림만 받아볼까요?", isPresented: $explain, titleVisibility: .visible) {
            Button("알림 켜기") { if let proposed { save(proposed, permission: true) }; proposed = nil }
            Button("취소", role: .cancel) { proposed = nil }
        } message: { Text("선택한 계획·실행 알림에만 알림과 소리 권한을 사용해요. 나중에 각각 끌 수 있어요.") }
        .sheet(isPresented: $choosingTime) {
            NavigationStack {
                Form {
                    DatePicker("날짜별 묶음 알림 시각", selection: $selectedTime, displayedComponents: .hourAndMinute).environment(\.timeZone, .gmt)
                    if let message = notifications.message { Text(message) }
                }
                    .navigationTitle("알림 시각")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) { Button("취소") { choosingTime = false } }
                        ToolbarItem(placement: .confirmationAction) { Button("선택") {
                            var draft = notifications.state.preferences
                            draft.executionMinutes = minutes(selectedTime); save(draft, dismissTimeOnSuccess: true)
                        }.disabled(busy) }
                    }
            }
        }
        .notificationPresentation(owner: "settings", blocked: explain || choosingTime || busy)
    }
    private var permissionLabel: String {
        switch notifications.authorization {
        case .notDetermined: "알림을 켤 때 iPhone 권한을 요청해요."
        case .denied: "iPhone에서 알림이 꺼져 있어요. 계획은 계속 사용할 수 있어요."
        case .authorized: "iPhone 알림이 허용되어 있어요."
        case .provisional: "조용한 알림이 허용되어 있어요."
        case .ephemeral: "알림이 일시적으로 허용되어 있어요."
        case .unknown: "iPhone 알림 상태를 확인하는 중이에요."
        }
    }
    private func toggle(_ key: WritableKeyPath<NotificationPreferences, Bool>) -> Binding<Bool> {
        Binding(get: { notifications.state.preferences[keyPath: key] }, set: { enabled in
            var draft = notifications.state.preferences; draft[keyPath: key] = enabled
            if enabled { proposed = draft; explain = true } else { save(draft) }
        })
    }
    private func value(_ key: WritableKeyPath<NotificationPreferences, Int>) -> Binding<Int> {
        Binding(get: { notifications.state.preferences[keyPath: key] }, set: { newValue in
            var draft = notifications.state.preferences; draft[keyPath: key] = newValue; save(draft)
        })
    }
    private func time(_ key: WritableKeyPath<NotificationPreferences, Int>) -> Binding<Date> {
        Binding(get: { pickerDate(notifications.state.preferences[keyPath: key]) }, set: { date in
            var draft = notifications.state.preferences; draft[keyPath: key] = minutes(date); save(draft)
        })
    }
    private func pickerDate(_ minutes: Int) -> Date { Date(timeIntervalSince1970: Double(minutes * 60)) }
    private func minutes(_ date: Date) -> Int {
        let calendar = LocalDate.calendar(in: .gmt)
        return calendar.component(.hour, from: date) * 60 + calendar.component(.minute, from: date)
    }
    private func save(_ draft: NotificationPreferences, permission: Bool = false, dismissTimeOnSuccess: Bool = false) {
        busy = true
        Task {
            let success = await notifications.updatePreferences(draft, requestPermission: permission)
            if success && dismissTimeOnSuccess { choosingTime = false }
            busy = false
        }
    }
}
