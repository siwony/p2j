import Foundation

/// Independent from the frozen app schemas. Failed IO never installs a new in-memory state.
struct NotificationStateStore {
    let url: URL
    var write: (Data, URL) throws -> Void = { data, url in try data.write(to: url, options: .atomic) }
    static var applicationStore: Self {
        let directory = URL.applicationSupportDirectory.appending(path: "Hanju", directoryHint: .isDirectory)
        return Self(url: directory.appending(path: "notifications-v1.json"))
    }
    func load() throws -> NotificationPersistentState {
        let data: Data
        do { data = try Data(contentsOf: url) }
        catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
            return NotificationPersistentState()
        }
        let state = try JSONDecoder().decode(NotificationPersistentState.self, from: data)
        try validate(state)
        return state
    }
    private func validate(_ state: NotificationPersistentState) throws {
        guard state.formatVersion == 1, state.preferences.isValid, state.tickets.count <= 256,
              Set(state.normalCheckpoints.map { $0.civil.id }).count == state.normalCheckpoints.count,
              state.normalCheckpoints.allSatisfy({ $0.civil.isValid && ($0.resolvedDue == nil || $0.resolvedDue!.timeIntervalSince1970.isFinite) }),
              Set(state.tickets.map(\.id)).count == state.tickets.count,
              state.tickets.allSatisfy({ ticket in
                  ticket.id.hasPrefix(NotificationPlan.prefix) && ticket.dueAt.timeIntervalSince1970.isFinite &&
                  Set(ticket.targets.map(\.id)).count == ticket.targets.count &&
                  ticket.targets.allSatisfy { LocalDate(key: $0.dayKey) != nil && $0.updatedAt.timeIntervalSince1970.isFinite && $0.revision >= 0 }
              }) else { throw NotificationFailure.state }
    }
    func save(_ state: NotificationPersistentState) throws {
        try validate(state)
        let data = try JSONEncoder().encode(state)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try write(data, url)
    }
}

enum NotificationFailure: LocalizedError {
    case state, changed, capacity, trigger
    var errorDescription: String? {
        switch self {
        case .state: "알림 설정을 읽거나 저장하지 못했어요. 기존 설정과 계획은 보존돼요. 다시 시도해주세요."
        case .changed: "이 알림의 일정이 변경됐거나 이미 처리됐어요. 현재 계획에서 확인해주세요."
        case .capacity: "잠시 미룰 알림 여유가 없어요. 설정에서 예약 상태를 확인해주세요."
        case .trigger: "알림 시각을 확인하지 못했어요. 계획은 저장되어 있어요. 다시 시도해주세요."
        }
    }
}
