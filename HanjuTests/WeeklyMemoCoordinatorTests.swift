import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class WeeklyMemoCoordinatorTests: XCTestCase {
    private let week = LocalDate(year: 2026, month: 10, day: 5)!
    private enum Failure: Error { case disk }

    func testReloadFailureRetriesReadWithoutWritingOrLosingLoadedMemo() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let original = "  기존 원문\n다음 줄  "
        _ = try RecordsStore.saveMemo(week: week, body: original, in: context)
        var shouldFail = false
        var reads: [LocalDate] = []
        var writes = 0
        let coordinator = WeeklyMemoCoordinator(read: { week, context in
            reads.append(week)
            if shouldFail { throw Failure.disk }
            return try RecordsStore.fetchMemo(week: week, in: context)
        }, write: { week, body, context in
            writes += 1
            return try RecordsStore.saveMemo(week: week, body: body, in: context)
        })
        coordinator.load(week: week, in: context)
        shouldFail = true
        coordinator.load(week: week.adding(days: 2), in: context)
        let failed = coordinator.draft(for: week)
        XCTAssertEqual(failed.body, original)
        XCTAssertEqual(failed.savedBody, original)
        XCTAssertTrue(failed.isLoaded)
        XCTAssertFalse(failed.isDirty)
        guard case .failed = failed.status else { return XCTFail("Reload failure was not retained") }
        XCTAssertEqual(reads, [week, week])
        XCTAssertEqual(writes, 0)

        shouldFail = false
        coordinator.retry(week: week.adding(days: 3), in: context)
        XCTAssertEqual(reads, [week, week, week])
        XCTAssertEqual(writes, 0)
        XCTAssertEqual(coordinator.draft(for: week).body, original)
        XCTAssertEqual(coordinator.draft(for: week).savedBody, original)
        XCTAssertEqual(coordinator.draft(for: week).status, .idle)
        XCTAssertEqual(coordinator.draft(for: week.adding(days: 7)), WeeklyMemoCoordinator.Draft())
    }

    func testEditingAfterReloadFailureRetriesWriteInsteadOfDiscardingDraft() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let context = container.mainContext
        _ = try RecordsStore.saveMemo(week: week, body: "기존 메모", in: context)
        var shouldFail = false
        var reads = 0
        var writes: [String] = []
        let coordinator = WeeklyMemoCoordinator(read: { week, context in
            reads += 1
            if shouldFail { throw Failure.disk }
            return try RecordsStore.fetchMemo(week: week, in: context)
        }, write: { week, body, context in
            writes.append(body)
            return try RecordsStore.saveMemo(week: week, body: body, in: context)
        })
        coordinator.load(week: week, in: context)
        shouldFail = true
        coordinator.load(week: week, in: context)
        let edited = "  읽기 실패 뒤 편집\n원문  "
        coordinator.update(body: edited, week: week, in: context)
        coordinator.retry(week: week, in: context)
        XCTAssertEqual(reads, 2)
        XCTAssertEqual(writes, [edited])
        XCTAssertEqual(coordinator.draft(for: week).savedBody, edited)
        XCTAssertEqual(coordinator.draft(for: week).status, .saved)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: week, in: context).body, edited)
    }

    func testDebounceKeepsLatestTextAndCapturedWeekWithoutDuplicateFlush() async throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let context = container.mainContext
        var writes: [(LocalDate, String)] = []
        let coordinator = WeeklyMemoCoordinator(debounceNanoseconds: 10_000_000, write: { week, body, context in
            writes.append((week, body))
            return try RecordsStore.saveMemo(week: week, body: body, in: context)
        })
        let next = week.adding(days: 7)
        coordinator.load(week: week, in: context); coordinator.load(week: next, in: context)
        coordinator.update(body: "old", week: week, in: context)
        coordinator.update(body: "  마지막 입력\n다음 줄  ", week: week.adding(days: 2), in: context)
        coordinator.update(body: "다음 주", week: next, in: context)
        coordinator.flush(week: next, in: context)
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(writes.count, 2)
        XCTAssertEqual(writes.filter { $0.0 == week }.map(\.1), ["  마지막 입력\n다음 줄  "])
        XCTAssertEqual(try RecordsStore.fetchMemo(week: next, in: context).body, "다음 주")
        XCTAssertEqual(coordinator.draft(for: week).status, .saved)
        coordinator.flushAll(in: context)
        XCTAssertEqual(writes.count, 2)
    }

    func testFailedWeekDraftSurvivesOtherWeekSaveReloadAndRetry() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let context = container.mainContext
        _ = try RecordsStore.saveMemo(week: week, body: "원래 메모", in: context)
        var shouldFail = true
        var reads = 0
        var writes: [String] = []
        let coordinator = WeeklyMemoCoordinator(read: { week, context in
            reads += 1
            return try RecordsStore.fetchMemo(week: week, in: context)
        }, write: { target, body, context in
            writes.append(body)
            return try RecordsStore.saveMemo(week: target, body: body, in: context, save: { transaction in
                if target == self.week && shouldFail { throw Failure.disk }
                try transaction.save()
            })
        })
        let original = "  실패해도 남을 원문\n🙂  "
        coordinator.load(week: week, in: context)
        coordinator.update(body: original, week: week, in: context)
        coordinator.flush(week: week, in: context)
        guard case .failed = coordinator.draft(for: week).status else { return XCTFail("Failed save was reported as success") }
        XCTAssertEqual(try RecordsStore.fetchMemo(week: week, in: context).body, "원래 메모")
        let next = week.adding(days: 7)
        coordinator.load(week: next, in: context)
        coordinator.update(body: "별개의 주", week: next, in: context)
        coordinator.flushAll(in: context)
        coordinator.load(week: week, in: context)
        XCTAssertEqual(coordinator.draft(for: week).body, original)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: next, in: context).body, "별개의 주")
        shouldFail = false
        let readsBeforeRetry = reads
        let writesBeforeRetry = writes.count
        coordinator.retry(week: week, in: context)
        XCTAssertEqual(reads, readsBeforeRetry)
        XCTAssertEqual(writes.count, writesBeforeRetry + 1)
        XCTAssertEqual(writes.last, original)
        XCTAssertEqual(coordinator.draft(for: week).status, .saved)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: week, in: context).body, original)
        shouldFail = true
        coordinator.update(body: "", week: week, in: context)
        coordinator.flush(week: week, in: context)
        coordinator.load(week: week, in: context)
        XCTAssertEqual(coordinator.draft(for: week).body, "")
        XCTAssertTrue(coordinator.draft(for: week).isLoaded)
        XCTAssertTrue(coordinator.draft(for: week).isDirty)
        guard case .failed = coordinator.draft(for: week).status else { return XCTFail("Failed clearing lost its retry state") }
        XCTAssertEqual(try RecordsStore.fetchMemo(week: week, in: context).body, original)
        shouldFail = false
        let writesBeforeClearRetry = writes.count
        coordinator.retry(week: week, in: context)
        XCTAssertEqual(reads, readsBeforeRetry)
        XCTAssertEqual(writes.count, writesBeforeClearRetry + 1)
        XCTAssertEqual(writes.last, "")
        XCTAssertEqual(coordinator.draft(for: week).body, "")
        XCTAssertEqual(coordinator.draft(for: week).status, .saved)
        XCTAssertFalse(coordinator.draft(for: week).isDirty)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: week, in: context).body, "")
    }

    func testReadFailureCannotReplaceExistingMemoWithEmptyDraft() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let context = container.mainContext
        _ = try RecordsStore.saveMemo(week: week, body: "읽지 못한 기존 메모", in: context)
        var shouldFail = true
        let coordinator = WeeklyMemoCoordinator(read: { week, context in
            if shouldFail { throw Failure.disk }
            return try RecordsStore.fetchMemo(week: week, in: context)
        })
        coordinator.load(week: week, in: context)
        XCTAssertFalse(coordinator.draft(for: week).isLoaded)
        coordinator.update(body: "", week: week, in: context); coordinator.flushAll(in: context)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: week, in: context).body, "읽지 못한 기존 메모")
        shouldFail = false; coordinator.retry(week: week, in: context)
        XCTAssertEqual(coordinator.draft(for: week).body, "읽지 못한 기존 메모")
        XCTAssertTrue(coordinator.draft(for: week).isLoaded)
    }

    func testClearingAndReturningToSavedTextCancelPendingWrites() async throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let context = container.mainContext
        _ = try RecordsStore.saveMemo(week: week, body: "saved", in: context)
        var writes = 0
        let coordinator = WeeklyMemoCoordinator(debounceNanoseconds: 10_000_000, write: { week, body, context in
            writes += 1
            return try RecordsStore.saveMemo(week: week, body: body, in: context)
        })
        coordinator.load(week: week, in: context)
        coordinator.update(body: "temporary", week: week, in: context)
        coordinator.update(body: "saved", week: week, in: context)
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(writes, 0)
        coordinator.update(body: "", week: week, in: context)
        coordinator.flushAll(in: context)
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(writes, 1)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: week, in: context).body, "")
        let reopened = WeeklyMemoCoordinator()
        reopened.load(week: week, in: context)
        XCTAssertEqual(reopened.draft(for: week).body, "")
    }
}
