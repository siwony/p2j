import Foundation
import Observation
import SwiftData

@MainActor @Observable
final class WeeklyMemoCoordinator {
    enum Status: Equatable {
        case idle, pending, saving, saved, failed(String)
    }
    struct Draft: Equatable {
        var body = ""
        var savedBody = ""
        var isLoaded = false
        var generation = 0
        var status: Status = .idle
        var isDirty: Bool { body != savedBody }
    }

    private var drafts: [LocalDate: Draft] = [:]
    @ObservationIgnored private var pending: [LocalDate: Task<Void, Never>] = [:]
    @ObservationIgnored private let delay: UInt64
    @ObservationIgnored private let read: (LocalDate, ModelContext) throws -> WeeklyMemoSnapshot
    @ObservationIgnored private let write: (LocalDate, String, ModelContext) throws -> WeeklyMemoSnapshot

    init(debounceNanoseconds: UInt64 = 500_000_000,
         read: @escaping (LocalDate, ModelContext) throws -> WeeklyMemoSnapshot = { try RecordsStore.fetchMemo(week: $0, in: $1) },
         write: @escaping (LocalDate, String, ModelContext) throws -> WeeklyMemoSnapshot = { try RecordsStore.saveMemo(week: $0, body: $1, in: $2) }) {
        delay = debounceNanoseconds; self.read = read; self.write = write
    }

    func draft(for week: LocalDate) -> Draft { drafts[week.monday] ?? Draft() }

    func load(week: LocalDate, in context: ModelContext) {
        let week = week.monday
        guard drafts[week]?.isDirty != true else { return }
        do {
            let memo = try read(week, context)
            var entry = drafts[week] ?? Draft()
            entry.body = memo.body; entry.savedBody = memo.body; entry.isLoaded = true
            entry.status = .idle; drafts[week] = entry
        } catch {
            var entry = drafts[week] ?? Draft()
            entry.status = .failed(error.localizedDescription); drafts[week] = entry
        }
    }

    func update(body: String, week: LocalDate, in context: ModelContext) {
        let week = week.monday
        guard var entry = drafts[week], entry.isLoaded else { return }
        pending.removeValue(forKey: week)?.cancel()
        entry.body = body; entry.generation += 1
        entry.status = entry.isDirty ? .pending : .idle
        drafts[week] = entry
        guard entry.isDirty else { return }
        let generation = entry.generation
        pending[week] = Task { [weak self] in
            guard let self else { return }
            do { try await Task.sleep(nanoseconds: self.delay) }
            catch { return }
            guard !Task.isCancelled, self.drafts[week]?.generation == generation else { return }
            self.flush(week: week, in: context)
        }
    }

    func flush(week: LocalDate, in context: ModelContext) {
        let week = week.monday
        pending.removeValue(forKey: week)?.cancel()
        guard var entry = drafts[week], entry.isLoaded, entry.isDirty else { return }
        entry.status = .saving; drafts[week] = entry
        do {
            let memo = try write(week, entry.body, context)
            entry.savedBody = memo.body; entry.status = .saved
        } catch { entry.status = .failed(error.localizedDescription) }
        drafts[week] = entry
    }

    func flushAll(in context: ModelContext) {
        for week in drafts.keys.sorted() { flush(week: week, in: context) }
    }

    func retry(week: LocalDate, in context: ModelContext) {
        if draft(for: week).isDirty { flush(week: week, in: context) }
        else { load(week: week, in: context) }
    }
}
