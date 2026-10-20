import Foundation
import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class RecordsTests: XCTestCase {
    private let monday = LocalDate(year: 2026, month: 10, day: 5)!
    private let process = UUID()
    private enum Failure: Error { case disk }

    private func sample(_ day: LocalDate, seconds: Double = 0) -> ExecutionClock.Sample {
        .init(wall: day.pickerDate.addingTimeInterval(seconds),
              nanoseconds: Int64((10_000 + seconds) * 1e9), processID: process)
    }

    private func fixture(_ count: Int, on day: LocalDate? = nil) throws -> (ModelContainer, [UUID]) {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let routine = RoutineTemplate(name: "원본 이름")
        container.mainContext.insert(routine)
        try container.mainContext.save()
        let entries = (0..<count).map { _ in
            PlanDraft.Entry(routineID: routine.id, name: "당시 이름", expectedMinutes: 25,
                            firstAction: "펼치기", day: day ?? monday)
        }
        if !entries.isEmpty {
            try PlanWriter.confirm(PlanDraft(week: (day ?? monday).monday, entries: entries), in: container.mainContext)
        }
        return (container, entries.map(\.id))
    }

    private func read(_ id: UUID, in container: ModelContainer) throws -> ExecutionSnapshot {
        try ExecutionWriter.snapshot(id, in: ModelContext(container))
    }

    private func records(_ week: LocalDate, in container: ModelContainer) throws -> WeeklyRecordsSnapshot {
        try RecordsStore.fetch(week: week, in: container.mainContext, at: sample(monday.adding(days: 14)))
    }

    func testPerformedDateCorrectionMovesBothWeekAggregatesWithoutMovingMemoOrPlan() throws {
        let sunday = monday.adding(days: -1)
        let (container, ids) = try fixture(1, on: sunday)
        let id = ids[0]
        _ = try RecordsStore.saveMemo(week: sunday, body: "지난주 메모", in: container.mainContext)
        _ = try RecordsStore.saveMemo(week: monday, body: "이번주 메모", in: container.mainContext)
        try ExecutionWriter.start(read(id, in: container), at: sample(monday), in: container.mainContext)
        try ExecutionWriter.complete(read(id, in: container), at: sample(monday, seconds: 12.25),
                                     timeZone: .gmt, in: container.mainContext)
        let original = try read(id, in: container)
        XCTAssertTrue(try records(sunday, in: container).completed.isEmpty)
        XCTAssertEqual(try records(monday, in: container).timeSummary.totalSeconds, 12.25)

        var draft = CompletionDraft(original)
        draft.performedOn = sunday
        // Discarding a draft never calls the save command.
        XCTAssertEqual(try records(monday, in: container).completed, [original])
        XCTAssertThrowsError(try ExecutionWriter.edit(original, draft: draft, today: monday,
            in: container.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(draft.performedOn, sunday)
        XCTAssertEqual(try records(monday, in: container).completed, [original])
        XCTAssertTrue(try records(sunday, in: container).completed.isEmpty)

        try ExecutionWriter.edit(original, draft: draft, today: monday, in: container.mainContext)
        let corrected = try XCTUnwrap(records(sunday, in: container).completed.first)
        XCTAssertTrue(try records(monday, in: container).completed.isEmpty)
        XCTAssertNil(try records(monday, in: container).timeSummary.totalSeconds)
        XCTAssertEqual(try records(sunday, in: container).routineCounts.first?.count, 1)
        XCTAssertEqual(try records(sunday, in: container).timeSummary.totalSeconds, 12.25)
        XCTAssertEqual(corrected.id, id)
        XCTAssertEqual(corrected.performedOn, sunday)
        XCTAssertEqual(corrected.completedAt, original.completedAt)
        XCTAssertEqual(corrected.completionDay, monday)
        XCTAssertEqual(corrected.intervals, original.intervals)
        XCTAssertEqual(corrected.occurrence, original.occurrence)
        XCTAssertTrue(try records(sunday, in: container).movedOccurrenceIDs.isEmpty)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: sunday, in: container.mainContext).body, "지난주 메모")
        XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: container.mainContext).body, "이번주 메모")
    }

    func testUndoAndRecompleteAcrossWeekBoundaryPreserveTimeAndRemoveOldAggregation() throws {
        let sunday = monday.adding(days: 6), nextMonday = monday.adding(days: 7)
        let (container, ids) = try fixture(1)
        let id = ids[0]
        try ExecutionWriter.start(read(id, in: container), at: sample(sunday), in: container.mainContext)
        try ExecutionWriter.complete(read(id, in: container), at: sample(sunday, seconds: 30),
                                     timeZone: .gmt, in: container.mainContext)
        let original = try read(id, in: container)
        XCTAssertThrowsError(try ExecutionWriter.undo(original, at: sample(nextMonday),
            in: container.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try records(monday, in: container).completed, [original])
        try ExecutionWriter.undo(original, at: sample(nextMonday), in: container.mainContext)
        let undone = try read(id, in: container)
        XCTAssertTrue(try records(monday, in: container).completed.isEmpty)
        XCTAssertNil(undone.completedAt)
        XCTAssertNil(undone.completionDay)
        XCTAssertNil(undone.performedOn)
        XCTAssertThrowsError(try ExecutionWriter.complete(undone, at: sample(nextMonday), timeZone: .gmt,
            in: container.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertTrue(try records(nextMonday, in: container).completed.isEmpty)
        try ExecutionWriter.complete(undone, at: sample(nextMonday), timeZone: .gmt, in: container.mainContext)
        let recompleted = try XCTUnwrap(records(nextMonday, in: container).completed.first)
        XCTAssertTrue(try records(monday, in: container).completed.isEmpty)
        XCTAssertEqual(recompleted.id, id)
        XCTAssertEqual(recompleted.performedOn, nextMonday)
        XCTAssertEqual(recompleted.completionDay, nextMonday)
        XCTAssertEqual(recompleted.completedAt, sample(nextMonday).wall)
        XCTAssertEqual(recompleted.intervals, original.intervals)
        XCTAssertEqual(try records(nextMonday, in: container).timeSummary.totalSeconds, 30)
    }

    func testAllUntimedCompletionsCountWithoutInventingZeroOrUsingExpectedTime() throws {
        let (container, ids) = try fixture(4)
        for id in ids.prefix(2) {
            try ExecutionWriter.complete(read(id, in: container), at: sample(monday),
                                         timeZone: .gmt, in: container.mainContext)
        }
        try PlanWriter.skip(read(ids[2], in: container).occurrence, in: container.mainContext)
        let result = try records(monday.adding(days: 6), in: container)
        XCTAssertEqual(result.week, monday)
        XCTAssertEqual(Set(result.completed.map(\.id)), Set(ids.prefix(2)))
        XCTAssertEqual(result.routineCounts.first?.count, 2)
        XCTAssertNil(result.timeSummary.totalSeconds)
        XCTAssertEqual(result.timeSummary.unrecordedCount, 2)
        XCTAssertEqual(result.timeSummary.needsReviewCount, 0)
        XCTAssertFalse(result.timeSummary.sumOverflow)
    }

    func testMixedDurationsExcludeUncertainPartialTimeAndKeepZeroAndSubminuteDistinct() throws {
        let (container, ids) = try fixture(4)
        for id in ids.prefix(2) {
            try ExecutionWriter.complete(read(id, in: container), at: sample(monday),
                                         timeZone: .gmt, in: container.mainContext)
        }
        let zero = try read(ids[1], in: container)
        var zeroDraft = CompletionDraft(zero)
        zeroDraft.minutes = "0"
        try ExecutionWriter.edit(zero, draft: zeroDraft, today: monday, in: container.mainContext)
        try ExecutionWriter.start(read(ids[2], in: container), at: sample(monday), in: container.mainContext)
        try ExecutionWriter.complete(read(ids[2], in: container), at: sample(monday, seconds: 12.25),
                                     timeZone: .gmt, in: container.mainContext)
        try ExecutionWriter.start(read(ids[3], in: container), at: sample(monday), in: container.mainContext)
        try ExecutionWriter.pause(read(ids[3], in: container), at: sample(monday, seconds: 60), in: container.mainContext)
        try ExecutionWriter.start(read(ids[3], in: container), at: sample(monday, seconds: 100), in: container.mainContext)
        let cold = ExecutionClock.Sample(wall: monday.pickerDate.addingTimeInterval(500),
                                        nanoseconds: 10_110_000_000_000, processID: UUID())
        try ExecutionWriter.complete(read(ids[3], in: container), at: cold, timeZone: .gmt, in: container.mainContext)
        let result = try records(monday, in: container)
        XCTAssertEqual(result.completed.count, 4)
        XCTAssertEqual(result.routineCounts.first?.count, 4)
        XCTAssertEqual(result.timeSummary.totalSeconds, 12.25)
        XCTAssertEqual(result.timeSummary.unrecordedCount, 1)
        XCTAssertEqual(result.timeSummary.needsReviewCount, 1)
        XCTAssertFalse(result.timeSummary.sumOverflow)
        XCTAssertEqual(try read(ids[1], in: container).duration(at: cold).seconds, 0)
        XCTAssertEqual(try read(ids[2], in: container).duration(at: cold).seconds, 12.25)
        let uncertain = try read(ids[3], in: container).duration(at: cold)
        XCTAssertNil(uncertain.seconds)
        XCTAssertEqual(uncertain.knownSeconds, 60)
        XCTAssertTrue(uncertain.needsReview)
    }

    func testCountsUseRoutineIdentityAndHistoricalNamesAfterArchiveAndRename() throws {
        let (container, ids) = try fixture(2)
        let first = try read(ids[0], in: container)
        let other = RoutineTemplate(name: "당시 이름")
        container.mainContext.insert(other)
        try container.mainContext.save()
        let entry = PlanDraft.Entry(routineID: other.id, name: "당시 이름", expectedMinutes: nil,
                                    firstAction: nil, day: monday)
        try PlanWriter.confirm(PlanDraft(week: monday, entries: [entry]), in: container.mainContext)
        for id in ids + [entry.id] {
            try ExecutionWriter.complete(read(id, in: container), at: sample(monday),
                                         timeZone: .gmt, in: container.mainContext)
        }
        let routines = try container.mainContext.fetch(FetchDescriptor<RoutineTemplate>())
        for routine in routines { routine.name = "바뀐 원본"; routine.isArchived = true }
        try container.mainContext.save()
        let result = try records(monday, in: container)
        XCTAssertEqual(result.routineCounts.count, 2)
        XCTAssertEqual(result.routineCounts.first { $0.routineID == first.occurrence.routineID }?.count, 2)
        XCTAssertEqual(result.routineCounts.first { $0.routineID == other.id }?.count, 1)
        XCTAssertTrue(result.routineCounts.allSatisfy { $0.name == "당시 이름" })
        XCTAssertTrue(result.completed.allSatisfy { $0.occurrence.name == "당시 이름" })
    }

    func testCapturedPerformedDateKeepsItsWeekAfterWestwardTimeZoneChange() throws {
        let (container, ids) = try fixture(1)
        let instant = try Date("2026-10-04T15:30:00Z", strategy: .iso8601)
        let now = ExecutionClock.Sample(wall: instant, nanoseconds: 1_000_000_000, processID: process)
        let seoul = try XCTUnwrap(TimeZone(identifier: "Asia/Seoul"))
        let honolulu = try XCTUnwrap(TimeZone(identifier: "Pacific/Honolulu"))
        try ExecutionWriter.complete(read(ids[0], in: container), at: now, timeZone: seoul, in: container.mainContext)
        let original = try read(ids[0], in: container)
        let localToday = LocalDate(instant, timeZone: honolulu)
        XCTAssertEqual(localToday, monday.adding(days: -1))
        var draft = CompletionDraft(original)
        draft.minutes = "0"
        try ExecutionWriter.edit(original, draft: draft, today: localToday, in: container.mainContext)
        let result = try records(monday, in: container)
        XCTAssertEqual(result.completed.first?.performedOn, monday)
        XCTAssertEqual(result.completed.first?.completionDay, monday)
        XCTAssertEqual(result.completed.first?.completedAt, instant)
        XCTAssertEqual(result.timeSummary.totalSeconds, 0)
        XCTAssertTrue(try records(localToday, in: container).completed.isEmpty)
    }

    func testMemoEmptyClearWeekIsolationFailureAndRetryPreserveExactBody() throws {
        let (container, _) = try fixture(0)
        let next = monday.adding(days: 7)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: container.mainContext).body, "")
        _ = try RecordsStore.saveMemo(week: monday, body: "", in: container.mainContext)
        let body = "  자유롭게\n빈 줄도 그대로\n\n"
        _ = try RecordsStore.saveMemo(week: monday.adding(days: 6), body: body, in: container.mainContext)
        _ = try RecordsStore.saveMemo(week: next, body: "다음 주", in: container.mainContext)
        XCTAssertThrowsError(try RecordsStore.saveMemo(week: monday, body: "실패한 초안",
            in: container.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: container.mainContext).body, body)
        _ = try RecordsStore.saveMemo(week: monday, body: "실패한 초안", in: container.mainContext)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: container.mainContext).body, "실패한 초안")
        XCTAssertThrowsError(try RecordsStore.saveMemo(week: monday, body: "",
            in: container.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: container.mainContext).body, "실패한 초안")
        _ = try RecordsStore.saveMemo(week: monday, body: "", in: container.mainContext)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: container.mainContext).body, "")
        XCTAssertEqual(try RecordsStore.fetchMemo(week: next, in: container.mainContext).body, "다음 주")
        XCTAssertTrue(try records(monday, in: container).completed.isEmpty)
    }

    func testDateMoveEvidenceIsAtomicStickyAndNotCreatedByTimeOnlyChanges() throws {
        let (container, ids) = try fixture(1)
        let original = try read(ids[0], in: container).occurrence
        try PlanWriter.move(original, to: monday, time: LocalTime(minutes: 540), in: container.mainContext)
        XCTAssertEqual(try ModelContext(container).fetchCount(FetchDescriptor<OccurrenceDateMove>()), 0)
        let timed = try read(ids[0], in: container).occurrence
        let tomorrow = monday.adding(days: 1)
        XCTAssertThrowsError(try PlanWriter.move(timed, to: tomorrow, time: nil, in: container.mainContext,
                                                 save: { _ in throw Failure.disk }))
        XCTAssertEqual(try read(ids[0], in: container).occurrence, timed)
        XCTAssertEqual(try ModelContext(container).fetchCount(FetchDescriptor<OccurrenceDateMove>()), 0)
        try PlanWriter.move(timed, to: tomorrow, time: nil, in: container.mainContext)
        try PlanWriter.move(timed, to: tomorrow, time: nil, in: container.mainContext)
        let firstMove = try XCTUnwrap(ModelContext(container).fetch(FetchDescriptor<OccurrenceDateMove>()).first)
        XCTAssertEqual(firstMove.fromDayKey, monday.key)
        XCTAssertEqual(firstMove.toDayKey, tomorrow.key)
        try PlanWriter.move(read(ids[0], in: container).occurrence, to: monday, time: nil, in: container.mainContext)
        let evidence = try ModelContext(container).fetch(FetchDescriptor<OccurrenceDateMove>())
        XCTAssertEqual(evidence.count, 1)
        XCTAssertEqual(evidence.first?.fromDayKey, monday.key)
        XCTAssertEqual(evidence.first?.toDayKey, tomorrow.key)
        try ExecutionWriter.complete(read(ids[0], in: container), at: sample(monday),
                                     timeZone: .gmt, in: container.mainContext)
        XCTAssertEqual(try records(monday, in: container).movedOccurrenceIDs, Set(ids))
    }

    func testReplanAndRestorePersistDateEvidenceInTheSameSave() throws {
        let (container, ids) = try fixture(3)
        let sources = try ids.prefix(2).map { try read($0, in: container).occurrence }
        let tomorrow = monday.adding(days: 1)
        XCTAssertThrowsError(try PlanWriter.replan(sources, to: tomorrow, today: tomorrow,
            in: container.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try ModelContext(container).fetchCount(FetchDescriptor<OccurrenceDateMove>()), 0)
        XCTAssertEqual(try ids.prefix(2).map { try read($0, in: container).occurrence }, sources)
        try PlanWriter.replan(sources, to: tomorrow, today: tomorrow, in: container.mainContext)
        try PlanWriter.replan(sources, to: tomorrow, today: tomorrow, in: container.mainContext)
        try PlanWriter.skip(read(ids[2], in: container).occurrence, in: container.mainContext)
        let skipped = try read(ids[2], in: container).occurrence
        XCTAssertThrowsError(try PlanWriter.move(skipped, to: tomorrow, time: nil, restore: true,
            in: container.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try read(ids[2], in: container).occurrence, skipped)
        XCTAssertEqual(try ModelContext(container).fetchCount(FetchDescriptor<OccurrenceDateMove>()), 2)
        try PlanWriter.move(skipped, to: monday, time: nil, restore: true, in: container.mainContext)
        XCTAssertEqual(try ModelContext(container).fetchCount(FetchDescriptor<OccurrenceDateMove>()), 2)
        try PlanWriter.skip(read(ids[2], in: container).occurrence, in: container.mainContext)
        try PlanWriter.move(read(ids[2], in: container).occurrence, to: tomorrow, time: nil,
                            restore: true, in: container.mainContext)
        let evidence = try ModelContext(container).fetch(FetchDescriptor<OccurrenceDateMove>())
        XCTAssertEqual(Set(evidence.map(\.occurrenceID)), Set(ids))
        XCTAssertTrue(evidence.allSatisfy { $0.fromDayKey == monday.key && $0.toDayKey == tomorrow.key })
    }

    func testOverflowNeverDisplaysPartialSumAsTotal() throws {
        let (container, ids) = try fixture(2)
        let transaction = ModelContext(container)
        for id in ids {
            let occurrence = try ExecutionWriter.find(id, in: transaction)
            occurrence.statusRaw = "completed"
            let record = ExecutionRecord(occurrenceID: id)
            record.completedAt = monday.pickerDate
            record.completionDayKey = monday.key
            record.performedDayKey = monday.key
            record.manualSeconds = Double.greatestFiniteMagnitude
            record.manualThroughSequence = 0
            transaction.insert(record)
        }
        try transaction.save()
        let result = try records(monday, in: container)
        XCTAssertEqual(result.completed.count, 2)
        XCTAssertNil(result.timeSummary.totalSeconds)
        XCTAssertTrue(result.timeSummary.sumOverflow)
        XCTAssertEqual(result.timeSummary.unrecordedCount, 0)
        XCTAssertEqual(result.timeSummary.needsReviewCount, 0)
    }
}
