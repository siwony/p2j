import Foundation
import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class WeekPlanTests: XCTestCase {
    private let monday = LocalDate(year: 2026, month: 10, day: 5)!
    private let routineID = UUID()
    private enum Failure: Error { case disk }
    private func container() throws -> ModelContainer {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        container.mainContext.insert(RoutineTemplate(name: "읽기", id: routineID))
        try container.mainContext.save()
        return container
    }
    private func entry(day: LocalDate? = nil, minutes: Int? = 25) -> PlanDraft.Entry {
        PlanDraft.Entry(routineID: routineID, name: "읽기", expectedMinutes: minutes, firstAction: "책 펴기", day: day ?? monday)
    }
    private func fetch(_ context: ModelContext, week: LocalDate? = nil) throws -> [OccurrenceSnapshot] {
        try PlanWriter.fetch(week: week ?? monday, in: context)
    }
    private func changeStatus(_ id: UUID, to status: String, container: ModelContainer) throws {
        let context = ModelContext(container)
        let model = try XCTUnwrap(context.fetch(FetchDescriptor<PlannedOccurrence>(predicate: #Predicate { $0.id == id })).first)
        model.statusRaw = status; model.updatedAt = Date().addingTimeInterval(1)
        try context.save()
    }

    func testGregorianDatesWeekBoundariesAndDSTResolution() throws {
        XCTAssertNil(LocalDate(year: 2026, month: 2, day: 29))
        XCTAssertNotNil(LocalDate(year: 2028, month: 2, day: 29))
        XCTAssertNil(LocalDate(year: 2026, month: 13, day: 1))
        XCTAssertNil(LocalDate(key: 20260431))
        XCTAssertNil(LocalTime(hour: 24, minute: 0))
        XCTAssertNil(LocalTime(minutes: -1))
        XCTAssertNil(LocalTime(hour: 1, minute: 60))
        XCTAssertEqual(monday.weekday, 1)
        XCTAssertEqual(monday.adding(days: 6).weekday, 7)
        XCTAssertEqual(monday.adding(days: 6).monday, monday)
        XCTAssertEqual(monday.adding(days: 7).monday, monday.adding(days: 7))
        let yearEnd = try XCTUnwrap(LocalDate(year: 2027, month: 1, day: 1))
        XCTAssertEqual(yearEnd.monday.key, 20261228)
        let la = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
        let spring = try XCTUnwrap(LocalDate(year: 2026, month: 3, day: 8))
        let gap = try XCTUnwrap(LocalTime(hour: 2, minute: 30)?.resolve(on: spring, in: la))
        XCTAssertEqual(LocalDate.calendar(in: la).component(.hour, from: gap.instant), 3)
        XCTAssertEqual(LocalDate.calendar(in: la).component(.minute, from: gap.instant), 0)
        XCTAssertNotNil(gap.explanation)
        let autumn = try XCTUnwrap(LocalDate(year: 2026, month: 11, day: 1))
        let fold = try XCTUnwrap(LocalTime(hour: 1, minute: 30)?.resolve(on: autumn, in: la))
        XCTAssertNotNil(fold.explanation)
        XCTAssertEqual(la.secondsFromGMT(for: fold.instant), -7 * 3600)
        let seoul = try XCTUnwrap(TimeZone(identifier: "Asia/Seoul"))
        let time = try XCTUnwrap(LocalTime(hour: 9, minute: 0))
        let korean = try XCTUnwrap(time.resolve(on: monday, in: seoul))
        let american = try XCTUnwrap(time.resolve(on: monday, in: la))
        XCTAssertEqual(LocalDate(korean.instant, timeZone: seoul), monday)
        XCTAssertEqual(LocalDate(american.instant, timeZone: la), monday)
        XCTAssertNotEqual(korean.instant, american.instant)
        XCTAssertEqual(monday.key, 20261005)
    }

    func testBatchAndWorkloadBoundariesDoNotOverflowOrAlterInputs() throws {
        XCTAssertEqual(try PlanDraft.validateCounts(["40", "60"]), [40, 60])
        for values in [["101"], [String(Int.max)], [String(Int.max), String(Int.max)], ["60", "41"], ["0"], ["-1"], ["1.5"], ["99999999999999999999999999"]] {
            XCTAssertThrowsError(try PlanDraft.validateCounts(values))
        }
        XCTAssertThrowsError(try PlanDraft.validateCounts(["1"], existing: 100))
        XCTAssertEqual(DayWorkload.label([Int.max, 1]), "예상 시간 합계가 표시 범위를 넘었어요")
        XCTAssertEqual(DayWorkload.label([nil, 5]), "예상 5분 · 예상 시간 미정 포함")
        XCTAssertEqual(DayWorkload.label([nil]), "예상 시간 미정")
        let container = try container()
        let large = PlanDraft(week: monday, entries: (0..<101).map { _ in entry() })
        XCTAssertThrowsError(try PlanWriter.confirm(large, in: container.mainContext))
        XCTAssertTrue(try fetch(container.mainContext).isEmpty)
        let allowed = PlanDraft(week: monday, entries: Array(large.entries.prefix(100)))
        try PlanWriter.confirm(allowed, in: container.mainContext)
        XCTAssertEqual(try fetch(container.mainContext).count, 100)
        try PlanWriter.confirm(PlanDraft(week: monday, entries: [entry()]), in: container.mainContext)
        XCTAssertEqual(try fetch(container.mainContext).count, 101)
    }

    func testConfirmRollbackStableRetrySnapshotAndReopen() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appending(path: "plan.store")
        let id = UUID()
        try writeAndModifyPlan(url: url, routineID: id)
        let reopened = try PersistenceStore.makeContainer(storeURL: url)
        let rows = try fetch(reopened.mainContext)
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(rows.first?.name, "원래 이름")
        XCTAssertEqual(rows.first?.expectedMinutes, 25)
        XCTAssertEqual(rows.first?.firstAction, "펼치기")
        XCTAssertEqual(rows.first?.routineID, id)
    }
    private func writeAndModifyPlan(url: URL, routineID: UUID) throws {
        let container = try PersistenceStore.makeContainer(storeURL: url)
        let context = container.mainContext
        var routine = RoutineDraft(id: routineID, name: "원래 이름", expectedMinutesText: "25", firstAction: "펼치기")
        try RoutineWriter.persist(routine, updating: false, in: context)
        let draft = PlanDraft(week: monday, entries: [PlanDraft.Entry(routineID: routineID, name: routine.name, expectedMinutes: 25, firstAction: routine.firstAction, day: monday)])
        let untouched = RoutineTemplate(name: "다른 미저장 draft")
        context.insert(untouched)
        XCTAssertThrowsError(try PlanWriter.confirm(draft, in: context, save: { _ in throw Failure.disk }))
        XCTAssertTrue(context.insertedModelsArray.contains { $0.persistentModelID == untouched.persistentModelID })
        XCTAssertTrue(try fetch(context).isEmpty)
        XCTAssertEqual(draft.entries.first?.name, "원래 이름")
        try PlanWriter.confirm(draft, in: context)
        try PlanWriter.confirm(draft, in: context)
        XCTAssertEqual(try fetch(context).count, 1)
        routine.name = "바뀐 이름"; routine.expectedMinutesText = "99"; routine.firstAction = "다른 행동"
        try RoutineWriter.persist(routine, updating: true, in: context)
        try RoutineWriter.setArchived(true, id: routineID, in: context)
        let source = try XCTUnwrap(fetch(context).first)
        try PlanWriter.move(source, to: monday.adding(days: 1), time: nil, in: context)
        try PlanWriter.confirm(draft, in: context)
        XCTAssertEqual(try fetch(context).first?.day, monday.adding(days: 1))
        context.rollback()
    }

    func testAllocationUsesDefaultFrequencyRemainingPreferredDaysAndExplicitPastCandidates() throws {
        let c = try container()
        var routine = RoutineDraft(id: routineID, name: "읽기", weeklyFrequencyText: "9", preferredWeekdays: [1, 7])
        try RoutineWriter.persist(routine, updating: true, in: c.mainContext)
        let current = try RoutineWriter.fetch(in: c.mainContext, archived: false)
        let tuesday = monday.adding(days: 1)
        let draft = try PlanDraft.allocate(week: monday, earliest: tuesday, routines: current, counts: [:], previous: [])
        XCTAssertEqual(draft.entries.count, 9)
        XCTAssertTrue(draft.entries.allSatisfy { $0.day == monday.adding(days: 6) })
        XCTAssertEqual(Set(draft.entries.map(\.id)).count, 9)
        XCTAssertTrue(try fetch(c.mainContext).isEmpty)
        routine.preferredWeekdays = [1]
        try RoutineWriter.persist(routine, updating: true, in: c.mainContext)
        let amended = try RoutineWriter.fetch(in: c.mainContext, archived: false)
        let remaining = try PlanDraft.allocate(week: monday, earliest: tuesday, routines: amended, counts: [routineID: "2"], previous: [])
        XCTAssertEqual(remaining.entries.map(\.day), [tuesday, tuesday.adding(days: 1)])
        let priorMonday = monday.adding(days: -7)
        let oldDraft = PlanDraft(week: priorMonday, entries: [entry(day: priorMonday)])
        try PlanWriter.confirm(oldDraft, in: c.mainContext)
        let candidates = try fetch(c.mainContext, week: priorMonday)
        let imported = try PlanDraft.allocate(week: monday, earliest: tuesday, routines: [], counts: [:], previous: candidates)
        XCTAssertEqual(imported.entries.count, 1)
        XCTAssertEqual(imported.entries.first?.day, tuesday)
        XCTAssertNotEqual(imported.entries.first?.id, candidates.first?.id)
        XCTAssertTrue(try fetch(c.mainContext).isEmpty)
        let empty = try PlanDraft.allocate(week: monday, earliest: tuesday, routines: [], counts: [:], previous: [])
        XCTAssertTrue(empty.entries.isEmpty)
    }

    func testInactiveRoutineRejectsNewDraftWithoutLosingItButCommittedRetryIsSafe() throws {
        let c = try container()
        let draft = PlanDraft(week: monday, entries: [entry()])
        try RoutineWriter.setArchived(true, id: routineID, in: c.mainContext)
        XCTAssertThrowsError(try PlanWriter.confirm(draft, in: c.mainContext))
        XCTAssertEqual(draft.entries.first?.name, "읽기")
        XCTAssertTrue(try fetch(c.mainContext).isEmpty)
        XCTAssertEqual(try c.mainContext.fetchCount(FetchDescriptor<WeekPlan>()), 0)
        try RoutineWriter.setArchived(false, id: routineID, in: c.mainContext)
        try PlanWriter.confirm(draft, in: c.mainContext)
        try RoutineWriter.setArchived(true, id: routineID, in: c.mainContext)
        try PlanWriter.confirm(draft, in: c.mainContext)
        XCTAssertEqual(try fetch(c.mainContext).count, 1)
        let missing = PlanDraft(week: monday, entries: [PlanDraft.Entry(routineID: UUID(), name: "없는 루틴", expectedMinutes: nil, firstAction: nil, day: monday)])
        XCTAssertThrowsError(try PlanWriter.confirm(missing, in: c.mainContext))
        XCTAssertEqual(try fetch(c.mainContext).count, 1)
    }

    func testRestIsAtomicRetryableAndRestoresPausedIdentity() throws {
        let c = try container()
        let entries = (0..<5).map { _ in entry() }
        try PlanWriter.confirm(PlanDraft(week: monday, entries: entries), in: c.mainContext)
        let planned = try ExecutionWriter.snapshot(entries[1].id, in: ModelContext(c))
        try ExecutionWriter.start(planned, at: ExecutionClock.now(), in: c.mainContext)
        let started = try ExecutionWriter.snapshot(entries[1].id, in: ModelContext(c))
        try ExecutionWriter.pause(started, at: ExecutionClock.now(), in: c.mainContext)
        try changeStatus(entries[2].id, to: "completed", container: c)
        let before = try fetch(c.mainContext)
        let selected = before.filter { $0.isUnfinished }
        XCTAssertThrowsError(try PlanWriter.rest(selected, today: monday.adding(days: 1), in: c.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try fetch(c.mainContext), before)
        try PlanWriter.rest(selected, today: monday, in: c.mainContext)
        try PlanWriter.rest(selected, today: monday, in: c.mainContext)
        XCTAssertEqual(try fetch(c.mainContext).filter { $0.status == .skipped }.count, 4)
        XCTAssertEqual(try fetch(c.mainContext).first { $0.id == entries[2].id }?.status, .completed)
        let paused = try XCTUnwrap(fetch(c.mainContext).first { $0.id == entries[1].id })
        try PlanWriter.move(paused, to: monday.adding(days: 2), time: nil, restore: true, in: c.mainContext)
        XCTAssertEqual(try fetch(c.mainContext).first { $0.id == paused.id }?.status, .paused)
        try PlanWriter.confirm(PlanDraft(week: monday, entries: [entry()]), in: c.mainContext)
        XCTAssertEqual(try fetch(c.mainContext).filter { $0.status == .planned }.count, 1)
    }

    func testMidCommandRunningOrStaleFailureLeavesEveryItemUnchanged() throws {
        let c = try container()
        try PlanWriter.confirm(PlanDraft(week: monday, entries: [entry(), entry()]), in: c.mainContext)
        let before = try fetch(c.mainContext)
        let last = try XCTUnwrap(before.last)
        try changeStatus(last.id, to: "running", container: c)
        let running = try fetch(c.mainContext)
        XCTAssertThrowsError(try PlanWriter.rest(running, today: monday, in: c.mainContext))
        XCTAssertEqual(try fetch(c.mainContext), running)
        XCTAssertThrowsError(try PlanWriter.rest(before, today: monday, in: c.mainContext))
        XCTAssertEqual(try fetch(c.mainContext), running)
        let r = try XCTUnwrap(running.first { $0.status == .running })
        XCTAssertThrowsError(try PlanWriter.move(r, to: monday.adding(days: 1), time: nil, in: c.mainContext))
        XCTAssertThrowsError(try PlanWriter.skip(r, in: c.mainContext))
        XCTAssertEqual(try fetch(c.mainContext), running)
    }

    func testSelectiveRecoveryAndCrossWeekMoveDoNotCopyOrCarryOver() throws {
        let c = try container()
        try PlanWriter.rest([], today: monday, in: c.mainContext)
        XCTAssertEqual(try c.mainContext.fetchCount(FetchDescriptor<WeekPlan>()), 0)
        try PlanWriter.confirm(PlanDraft(week: monday, entries: [entry(), entry()]), in: c.mainContext)
        let before = try fetch(c.mainContext)
        let first = try XCTUnwrap(before.first)
        let tuesday = monday.adding(days: 1)
        XCTAssertThrowsError(try PlanWriter.replan([first], to: tuesday, today: tuesday, in: c.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try fetch(c.mainContext), before)
        try PlanWriter.replan([first], to: tuesday, today: tuesday, in: c.mainContext)
        try PlanWriter.replan([first], to: tuesday, today: tuesday, in: c.mainContext)
        XCTAssertEqual(try fetch(c.mainContext).filter { $0.day == tuesday }.count, 1)
        XCTAssertTrue(try fetch(c.mainContext, week: monday.adding(days: 7)).isEmpty)
        let moved = try XCTUnwrap(fetch(c.mainContext).first { $0.id == first.id })
        try PlanWriter.move(moved, to: monday.adding(days: 7), time: nil, in: c.mainContext)
        XCTAssertEqual(try fetch(c.mainContext).count, 1)
        XCTAssertEqual(try fetch(c.mainContext, week: monday.adding(days: 7)).first?.id, first.id)
        let next = try XCTUnwrap(c.mainContext.fetch(FetchDescriptor<WeekPlan>()).first { $0.mondayKey == monday.adding(days: 7).key })
        XCTAssertFalse(next.calendarConnected)
        XCTAssertThrowsError(try PlanWriter.replan([first], to: tuesday, today: tuesday, in: c.mainContext))
    }
}
