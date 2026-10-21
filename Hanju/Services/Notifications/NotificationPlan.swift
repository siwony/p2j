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

struct NotificationEventTime: Sendable {
    let instant: Date
    let timeZoneID: String
}

struct NotificationCivil: Codable, Equatable, Sendable {
    let id: UUID
    let dayKey: Int
    let ownMinutes: Int?
    let status: String
    init(_ source: ExecutionSnapshot) {
        id = source.id; dayKey = source.occurrence.day.key
        ownMinutes = source.occurrence.time?.minutes; status = source.occurrence.status.rawValue
    }
    init(id: UUID, dayKey: Int, ownMinutes: Int?, status: String) {
        self.id = id; self.dayKey = dayKey; self.ownMinutes = ownMinutes; self.status = status
    }
    var isValid: Bool {
        LocalDate(key: dayKey) != nil && (ownMinutes == nil || LocalTime(minutes: ownMinutes!) != nil) &&
        ["planned", "running", "paused", "completed", "skipped"].contains(status)
    }
}

struct NotificationCheckpoint: Codable, Equatable {
    var civil: NotificationCivil
    var resolvedDue: Date?
    var terminal: Bool
    var lastConsumedGeneration: UUID? = nil
}

struct NotificationStartedNormal: Sendable {
    let civil: NotificationCivil
    let generation: UUID
}

struct NotificationSaveEvent: Sendable {
    let time: NotificationEventTime
    let rows: [NotificationCivil]
    let valid: Bool
    var startedNormal: NotificationStartedNormal? = nil
}

struct NotificationPersistentState: Codable, Equatable {
    var formatVersion = 1
    var preferences = NotificationPreferences()
    var tickets: [NotificationTicket] = []
    var normalCheckpoints: [NotificationCheckpoint] = []
    init() {}
    private enum CodingKeys: String, CodingKey { case formatVersion, preferences, tickets, normalCheckpoints }
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        formatVersion = try values.decode(Int.self, forKey: .formatVersion)
        preferences = try values.decode(NotificationPreferences.self, forKey: .preferences)
        tickets = try values.decode([NotificationTicket].self, forKey: .tickets)
        // Only absent v1 data is legacy; explicit null or corrupt checkpoints remain errors.
        normalCheckpoints = values.contains(.normalCheckpoints)
            ? try values.decode([NotificationCheckpoint].self, forKey: .normalCheckpoints) : []
    }
}

/// Produces intent only. The coordinator persists generations before calling the OS.
enum NotificationPlan {
    static let prefix = "hanju."
    static let budget = 64
    static let snoozeReserve = 8

    static func matchesCivil(_ ticket: NotificationTicket, _ civil: NotificationCivil) -> Bool {
        let kind: NotificationTicket.Kind = civil.ownMinutes == nil ? .group : .single
        let id = prefix + (civil.ownMinutes == nil ? "group.\(civil.dayKey)" : "single.\(civil.id)")
        guard ticket.kind == kind, ticket.id == id,
              ticket.targets.contains(where: { $0.id == civil.id && $0.dayKey == civil.dayKey }) else { return false }
        guard let minutes = civil.ownMinutes else { return true } // A default-time change is not a new civil plan.
        guard let day = LocalDate(key: civil.dayKey), let zone = TimeZone(identifier: ticket.timeZoneID) else { return false }
        // Resolve the original civil time, including DST gaps; its displayed hour may have shifted.
        return LocalTime(minutes: minutes)?.resolve(on: day, in: zone)?.instant == ticket.dueAt
    }

    static func checkpoints(sources: [ExecutionSnapshot], state: NotificationPersistentState,
                            events: [NotificationSaveEvent] = [], now: Date, timeZone: TimeZone) throws -> [NotificationCheckpoint] {
        var points = Dictionary(uniqueKeysWithValues: state.normalCheckpoints.map { ($0.civil.id, $0) })
        let currentSources = Dictionary(uniqueKeysWithValues: sources.map { ($0.id, $0) })
        func apply(_ civil: NotificationCivil, at instant: Date, zone: TimeZone) throws {
            guard civil.isValid, instant.timeIntervalSince1970.isFinite else { throw NotificationFailure.state }
            var point = points[civil.id]
            if point == nil {
                // Legacy receipts are evidence only when their original civil time still matches.
                let evidence = state.tickets.first { matchesCivil($0, civil) }
                // A surviving snooze proves consumption even when the bounded normal receipt was evicted.
                // Its fixed due time and generation are not evidence of the original normal's due or generation.
                let snoozed = currentSources[civil.id].map { source in
                    let current = NotificationCivil(source)
                    return current.dayKey == civil.dayKey && current.ownMinutes == civil.ownMinutes &&
                        state.tickets.contains { ticket in
                            ticket.kind == .snooze && !ticket.consumed && ticket.dueAt > instant &&
                                ticket.targets.contains { $0.matches(source) }
                        }
                } ?? false
                point = .init(civil: civil, resolvedDue: evidence?.dueAt,
                              terminal: (evidence.map { $0.consumed || $0.dueAt <= instant } ?? false) || snoozed,
                              lastConsumedGeneration: evidence?.consumed == true ? evidence?.generation : nil)
            }
            var current = point!
            if let due = current.resolvedDue, due <= instant { current.terminal = true }
            if let consumed = state.tickets.first(where: { ticket in
                ticket.consumed && ticket.generation != current.lastConsumedGeneration && matchesCivil(ticket, current.civil)
            }) { current.terminal = true; current.lastConsumedGeneration = consumed.generation }
            let moved = current.civil.dayKey != civil.dayKey || current.civil.ownMinutes != civil.ownMinutes
            let restored = current.civil.status == "skipped" && ["planned", "paused"].contains(civil.status)
            if moved || restored { current.terminal = false; current.resolvedDue = nil }
            current.civil = civil
            if !current.terminal, let day = LocalDate(key: civil.dayKey),
               let minutes = civil.ownMinutes ?? state.preferences.executionMinutes,
               let resolved = LocalTime(minutes: minutes)?.resolve(on: day, in: zone) {
                current.resolvedDue = resolved.instant
                current.terminal = resolved.instant <= instant
            }
            points[civil.id] = current
        }
        for event in events {
            guard event.valid, let zone = TimeZone(identifier: event.time.timeZoneID) else { throw NotificationFailure.state }
            for row in event.rows { try apply(row, at: event.time.instant, zone: zone) }
            if let started = event.startedNormal {
                if points[started.civil.id] == nil { try apply(started.civil, at: event.time.instant, zone: zone) }
                if var point = points[started.civil.id], point.civil.dayKey == started.civil.dayKey,
                   point.civil.ownMinutes == started.civil.ownMinutes {
                    point.terminal = true; point.lastConsumedGeneration = started.generation
                    points[started.civil.id] = point
                }
            }
        }
        for source in sources { try apply(NotificationCivil(source), at: now, zone: timeZone) }
        let currentIDs = Set(sources.map(\.id))
        return points.values.filter { currentIDs.contains($0.civil.id) }.sorted { $0.civil.id.uuidString < $1.civil.id.uuidString }
    }

    static func make(sources: [ExecutionSnapshot], state: NotificationPersistentState,
                     now: Date, timeZone: TimeZone, foreignPending: Int) throws -> [NotificationTicket] {
        let preferences = state.preferences
        let points = try checkpoints(sources: sources, state: state, now: now, timeZone: timeZone)
        let terminal = Set(points.filter(\.terminal).map { $0.civil.id })
        let eligible = sources.filter { $0.occurrence.canReplan && !terminal.contains($0.id) }.sorted { $0.id.uuidString < $1.id.uuidString }
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
            let old = state.tickets.first { $0.id == fresh.id && !$0.consumed && $0.sameSchedule(as: fresh) }
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
        let newIDs = Set((candidates + snoozes).map(\.id))
        let history = state.tickets.filter { old in
            (old.kind == .single || old.kind == .group) && !newIDs.contains(old.id) &&
            !old.targets.isEmpty && old.targets.allSatisfy { target in sourceByID[target.id].map(target.matches) == true }
        }
        let past = (candidates + snoozes + history).filter { !$0.isPlanning && ($0.dueAt <= now || $0.consumed) }
            .sorted { $0.dueAt > $1.dueAt }.prefix(128)
        return planning + selectedSnoozes + Array(future.prefix(normalLimit)) + past
    }

    static func waitingCount(sources: [ExecutionSnapshot], state: NotificationPersistentState, now: Date, timeZone: TimeZone) throws -> Int {
        let planningWaiting = state.preferences.planningEnabled && !state.tickets.contains(where: \.isPlanning) ? 1 : 0
        guard state.preferences.executionEnabled else { return planningWaiting }
        var future = Set<String>()
        let points = try checkpoints(sources: sources, state: state, now: now, timeZone: timeZone)
        let terminal = Set(points.filter(\.terminal).map { $0.civil.id })
        for source in sources where source.occurrence.canReplan && !terminal.contains(source.id) {
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
