import Foundation

struct NotificationPreferences: Codable, Equatable {
    var planningEnabled = false
    var executionEnabled = false
    var planningWeekday = 7 // Monday = 1, Sunday = 7.
    var planningMinutes = 20 * 60
    var executionMinutes: Int?
    var isValid: Bool {
        (1...7).contains(planningWeekday) && LocalTime(minutes: planningMinutes) != nil &&
        (executionMinutes == nil || LocalTime(minutes: executionMinutes!) != nil)
    }
}

/// Primitive, persisted versions; never a SwiftData object or a refreshed command snapshot.
struct NotificationTarget: Codable, Equatable, Sendable, Identifiable {
    let id: UUID
    let updatedAt: Date
    let revision: Int
    let dayKey: Int
    let name: String
    init(_ source: ExecutionSnapshot) {
        id = source.id; updatedAt = source.occurrence.updatedAt; revision = source.revision
        dayKey = source.occurrence.day.key; name = source.occurrence.name
    }
    func matches(_ source: ExecutionSnapshot) -> Bool {
        id == source.id && updatedAt == source.occurrence.updatedAt && revision == source.revision &&
        dayKey == source.occurrence.day.key && source.occurrence.canReplan
    }
}

struct NotificationTicket: Codable, Equatable, Sendable, Identifiable {
    enum Kind: String, Codable, Sendable { case single, group, planning, snooze }
    let id: String
    let generation: UUID
    let kind: Kind
    let targets: [NotificationTarget]
    let dueAt: Date
    let weekday: Int?
    let minutes: Int?
    let timeZoneID: String
    let explanation: String?
    var accepted = false
    var consumed = false
    func sameSchedule(as other: Self) -> Bool {
        id == other.id && kind == other.kind && targets == other.targets && dueAt == other.dueAt &&
        weekday == other.weekday && minutes == other.minutes && timeZoneID == other.timeZoneID
    }
    var isPlanning: Bool { kind == .planning }
}

struct NotificationEnvelope: Equatable, Sendable {
    enum Action: String, Sendable { case open, start, snooze }
    let requestID: String
    let generation: UUID
    let action: Action
}

struct NotificationRoute: Identifiable, Equatable {
    let id: UUID
    let ticket: NotificationTicket
    let action: NotificationEnvelope.Action
}

struct NotificationPersistentState: Codable, Equatable {
    var formatVersion = 1
    var preferences = NotificationPreferences()
    var tickets: [NotificationTicket] = []
}

/// Produces intent only. The coordinator persists generations before calling the OS.
enum NotificationPlan {
    static let prefix = "hanju."
    static let budget = 64
    static let snoozeReserve = 8

    static func make(sources: [ExecutionSnapshot], state: NotificationPersistentState,
                     now: Date, timeZone: TimeZone, foreignPending: Int) -> [NotificationTicket] {
        let preferences = state.preferences
        let eligible = sources.filter { $0.occurrence.canReplan }.sorted { $0.id.uuidString < $1.id.uuidString }
        var candidates: [NotificationTicket] = []
        if preferences.executionEnabled {
            var groups: [Int: [ExecutionSnapshot]] = [:]
            for source in eligible {
                let row = source.occurrence
                if let time = row.time, let resolved = time.resolve(on: row.day, in: timeZone) {
                    candidates.append(ticket(id: "single.\(row.id)", kind: .single, sources: [source],
                        dueAt: resolved.instant, timeZone: timeZone, explanation: resolved.explanation))
                } else if row.time == nil { groups[row.day.key, default: []].append(source) }
            }
            if let minutes = preferences.executionMinutes, let time = LocalTime(minutes: minutes) {
                for (key, sources) in groups {
                    guard let day = LocalDate(key: key), let resolved = time.resolve(on: day, in: timeZone) else { continue }
                    candidates.append(ticket(id: "group.\(key)", kind: .group, sources: sources,
                        dueAt: resolved.instant, timeZone: timeZone, explanation: resolved.explanation))
                }
            }
        }
        let sourceByID = Dictionary(uniqueKeysWithValues: sources.map { ($0.id, $0) })
        // Retain an accepted snooze's fixed instant; a retry never adds another 30 minutes.
        let snoozes = state.tickets.compactMap { old -> NotificationTicket? in
            guard old.kind == .snooze, preferences.executionEnabled else { return nil }
            let remaining = old.targets.filter { target in sourceByID[target.id].map(target.matches) == true }
            guard !remaining.isEmpty else { return nil }
            if remaining == old.targets { return old }
            return NotificationTicket(id: old.id, generation: UUID(), kind: .snooze, targets: remaining,
                dueAt: old.dueAt, weekday: nil, minutes: nil, timeZoneID: old.timeZoneID,
                explanation: old.explanation, accepted: old.accepted, consumed: old.consumed)
        }
        // A consumed delivered generation stays consumed while its unchanged schedule is retained.
        candidates = candidates.compactMap { fresh in
            let old = state.tickets.first { $0.id == fresh.id && $0.sameSchedule(as: fresh) }
            guard fresh.dueAt > now || old != nil else { return nil }
            return old ?? fresh
        }
        if preferences.planningEnabled {
            // Weekly trigger is deliberately the only repeating request.
            let planning = NotificationTicket(id: prefix + "planning", generation: UUID(), kind: .planning,
                targets: [], dueAt: .distantFuture, weekday: preferences.planningWeekday,
                minutes: preferences.planningMinutes, timeZoneID: timeZone.identifier, explanation: nil)
            candidates.append(state.tickets.first { $0.sameSchedule(as: planning) } ?? planning)
        }
        let available = max(0, budget - foreignPending)
        let planning = Array(candidates.filter(\.isPlanning).prefix(min(1, available)))
        let futureSnoozes = snoozes.filter { $0.dueAt > now && !$0.consumed }.sorted { $0.dueAt < $1.dueAt }
        let selectedSnoozes = futureSnoozes // Accepted future intents survive a later capacity decrease.
        let normalLimit = max(0, available - planning.count - max(snoozeReserve, selectedSnoozes.count))
        let future = candidates.filter { !$0.isPlanning && $0.dueAt > now && !$0.consumed }
            .sorted { $0.dueAt == $1.dueAt ? $0.id < $1.id : $0.dueAt < $1.dueAt }
        // Past generations are response receipts, not new OS requests. Keep storage bounded.
        let past = (candidates + snoozes).filter { !$0.isPlanning && ($0.dueAt <= now || $0.consumed) }
            .sorted { $0.dueAt > $1.dueAt }.prefix(128)
        return planning + selectedSnoozes + Array(future.prefix(normalLimit)) + past
    }

    static func waitingCount(sources: [ExecutionSnapshot], state: NotificationPersistentState, now: Date, timeZone: TimeZone) -> Int {
        let planningWaiting = state.preferences.planningEnabled && !state.tickets.contains(where: \.isPlanning) ? 1 : 0
        guard state.preferences.executionEnabled else { return planningWaiting }
        var future = Set<String>()
        for source in sources where source.occurrence.canReplan {
            let row = source.occurrence
            guard let time = row.time ?? state.preferences.executionMinutes.flatMap(LocalTime.init(minutes:)),
                  let due = time.resolve(on: row.day, in: timeZone)?.instant, due > now else { continue }
            future.insert(prefix + (row.time == nil ? "group.\(row.day.key)" : "single.\(row.id)"))
        }
        let known = Set(state.tickets.map(\.id))
        return future.subtracting(known).count + planningWaiting
    }

    private static func ticket(id: String, kind: NotificationTicket.Kind, sources: [ExecutionSnapshot],
                               dueAt: Date, timeZone: TimeZone, explanation: String?) -> NotificationTicket {
        .init(id: prefix + id, generation: UUID(), kind: kind, targets: sources.map(NotificationTarget.init),
              dueAt: dueAt, weekday: nil, minutes: nil, timeZoneID: timeZone.identifier, explanation: explanation)
    }
}
