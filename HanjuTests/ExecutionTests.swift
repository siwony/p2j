import Foundation
import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class ExecutionTests: XCTestCase {
    private let day = LocalDate(year: 2026, month: 10, day: 5)!
    private let process = UUID()
    private enum Failure: Error { case disk }
    private func sample(_ seconds: Double, wall: Double? = nil, process: UUID? = nil) -> ExecutionClock.Sample {
        .init(wall: day.pickerDate.addingTimeInterval(wall ?? seconds), nanoseconds: Int64((10_000 + seconds) * 1e9), processID: process ?? self.process)
    }
    private func fixture(_ count: Int = 2) throws -> (ModelContainer, [UUID]) {
        let c = try PersistenceStore.makeContainer(inMemory: true)
        let routine = RoutineTemplate(name: "책 읽기")
        c.mainContext.insert(routine); try c.mainContext.save()
        let entries = (0..<count).map { _ in PlanDraft.Entry(routineID: routine.id, name: "원래 이름", expectedMinutes: 25, firstAction: "펼치기", day: day) }
        try PlanWriter.confirm(PlanDraft(week: day, entries: entries), in: c.mainContext)
        return (c, entries.map(\.id))
    }
    private func read(_ id: UUID, _ c: ModelContainer) throws -> ExecutionSnapshot { try ExecutionWriter.snapshot(id, in: ModelContext(c)) }

    func testPauseResumeSwitchIsAtomicAndRepeatedCommandsDoNotDuplicateIntervals() throws {
        let (c, ids) = try fixture()
        let first = try read(ids[0], c), second = try read(ids[1], c)
        try ExecutionWriter.start(first, at: sample(0), in: c.mainContext)
        try ExecutionWriter.start(first, at: sample(1), in: c.mainContext)
        let running = try read(ids[0], c)
        XCTAssertEqual(running.intervals.count, 1)
        XCTAssertThrowsError(try ExecutionWriter.start(second, at: sample(10), in: c.mainContext))
        XCTAssertThrowsError(try ExecutionWriter.start(second, replacing: running, at: sample(10), in: c.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try read(ids[0], c), running)
        XCTAssertEqual(try read(ids[1], c), second)
        try ExecutionWriter.start(second, replacing: running, at: sample(10), in: c.mainContext)
        XCTAssertEqual(try read(ids[0], c).duration(at: sample(100)).seconds, 10)
        let active = try read(ids[1], c)
        try ExecutionWriter.pause(active, at: sample(20), in: c.mainContext)
        try ExecutionWriter.pause(active, at: sample(21), in: c.mainContext)
        let paused = try read(ids[1], c)
        XCTAssertEqual(paused.duration(at: sample(100)).seconds, 10)
        try ExecutionWriter.start(paused, at: sample(100), in: c.mainContext)
        try ExecutionWriter.complete(read(ids[1], c), at: sample(105), in: c.mainContext)
        XCTAssertEqual(try read(ids[1], c).duration(at: sample(500)).seconds, 15)
        XCTAssertNil(try ExecutionWriter.active(in: ModelContext(c)))
        XCTAssertEqual(try read(ids[1], c).intervals.count, 2)
    }

    func testDirectCompletionNilZeroSubminuteAndDateLifecyclePreserveOriginalFacts() throws {
        let (c, ids) = try fixture()
        let initial = try read(ids[0], c)
        let monday = sample(0)
        try ExecutionWriter.complete(initial, at: monday, timeZone: .gmt, in: c.mainContext)
        try ExecutionWriter.complete(initial, at: sample(100), timeZone: .gmt, in: c.mainContext)
        let complete = try read(ids[0], c)
        XCTAssertEqual(complete.completedAt, monday.wall)
        XCTAssertNil(complete.duration(at: sample(100)).seconds)
        XCTAssertEqual(complete.duration(at: sample(100)).label, "시간 미기록")
        var draft = CompletionDraft(complete); draft.performedOn = day.adding(days: -1)
        XCTAssertThrowsError(try ExecutionWriter.edit(complete, draft: draft, today: day, in: c.mainContext, save: { _ in throw Failure.disk }))
        XCTAssertEqual(try read(ids[0], c), complete)
        XCTAssertEqual(draft.performedOn, day.adding(days: -1))
        try ExecutionWriter.edit(complete, draft: draft, today: day, in: c.mainContext)
        let corrected = try read(ids[0], c)
        XCTAssertEqual(corrected.completedAt, complete.completedAt)
        XCTAssertEqual(corrected.completionDay, day)
        XCTAssertEqual(corrected.occurrence.day, day)
        XCTAssertEqual(try ExecutionWriter.completed(on: day.adding(days: -1), in: ModelContext(c)).count, 1)
        XCTAssertTrue(try ExecutionWriter.completed(on: day, in: ModelContext(c)).isEmpty)
        var future = CompletionDraft(corrected); future.performedOn = day.adding(days: 1)
        XCTAssertThrowsError(try ExecutionWriter.edit(corrected, draft: future, today: day, in: c.mainContext))
        XCTAssertThrowsError(try ExecutionWriter.undo(corrected, at: monday, in: c.mainContext, save: { _ in throw Failure.disk }))
        try ExecutionWriter.undo(corrected, at: monday, in: c.mainContext)
        let undone = try read(ids[0], c)
        XCTAssertNil(undone.completedAt); XCTAssertNil(undone.completionDay); XCTAssertNil(undone.performedOn)
        XCTAssertThrowsError(try ExecutionWriter.complete(initial, at: monday, in: c.mainContext))
        try ExecutionWriter.complete(undone, at: sample(86400), timeZone: .gmt, in: c.mainContext)
        let again = try read(ids[0], c)
        XCTAssertEqual(again.completionDay, day.adding(days: 1)); XCTAssertEqual(again.performedOn, day.adding(days: 1))
        var zero = CompletionDraft(again); zero.minutes = "0"
        try ExecutionWriter.edit(again, draft: zero, today: day.adding(days: 1), in: c.mainContext)
        XCTAssertEqual(try read(ids[0], c).duration(at: sample(90000)).label, "0분 기록")
        let second = try read(ids[1], c)
        try ExecutionWriter.start(second, at: sample(0), in: c.mainContext)
        try ExecutionWriter.complete(read(ids[1], c), at: sample(12.25), in: c.mainContext)
        let short = try read(ids[1], c)
        var shortEdit = CompletionDraft(short); shortEdit.performedOn = day.adding(days: -7)
        try ExecutionWriter.edit(short, draft: shortEdit, today: day, in: c.mainContext)
        let kept = try read(ids[1], c)
        XCTAssertEqual(kept.duration(at: sample(100)).seconds, 12.25)
        XCTAssertEqual(kept.duration(at: sample(100)).label, "1분 미만 기록")
        XCTAssertEqual(kept.intervals, short.intervals)
    }

    func testManualOverrideThenUndoResumeAddsOnlyNewIntervalsAndBlankRestoresMeasurement() throws {
        let (c, ids) = try fixture(1); let id = ids[0]
        try ExecutionWriter.start(read(id, c), at: sample(0), in: c.mainContext)
        try ExecutionWriter.complete(read(id, c), at: sample(40), in: c.mainContext)
        let source = try read(id, c)
        var draft = CompletionDraft(source); draft.minutes = "0"
        try ExecutionWriter.edit(source, draft: draft, today: day, in: c.mainContext)
        let overridden = try read(id, c)
        XCTAssertEqual(overridden.duration(at: sample(50)).seconds, 0)
        try ExecutionWriter.undo(overridden, at: sample(50), in: c.mainContext)
        try ExecutionWriter.start(read(id, c), at: sample(60), in: c.mainContext)
        try ExecutionWriter.complete(read(id, c), at: sample(75), in: c.mainContext)
        let again = try read(id, c)
        XCTAssertEqual(again.duration(at: sample(100)).seconds, 15)
        XCTAssertEqual(CompletionDraft(again).minutes, "0.25")
        var resetTotal = CompletionDraft(again); resetTotal.minutes = "0"
        try ExecutionWriter.edit(again, draft: resetTotal, today: day, in: c.mainContext)
        let reset = try read(id, c)
        XCTAssertEqual(reset.manualThroughSequence, 2)
        XCTAssertEqual(reset.duration(at: sample(100)).seconds, 0)
        var same = CompletionDraft(reset); let sameText = same.minutes; same.minutes = sameText
        try ExecutionWriter.edit(reset, draft: same, today: day, in: c.mainContext)
        let sameEdited = try read(id, c)
        var blank = CompletionDraft(sameEdited); blank.minutes = ""
        try ExecutionWriter.edit(sameEdited, draft: blank, today: day, in: c.mainContext)
        let measured = try read(id, c)
        XCTAssertEqual(measured.duration(at: sample(100)).seconds, 55)
        XCTAssertEqual(measured.intervals.count, 2)
        XCTAssertThrowsError(try ExecutionWriter.edit(again, draft: blank, today: day, in: c.mainContext))
    }

    func testClockChangeColdRecoveryUncertaintyAndExplicitCorrectionRetainRawIntervals() throws {
        let (c, ids) = try fixture(1); let id = ids[0]
        try ExecutionWriter.start(read(id, c), at: sample(0), in: c.mainContext)
        let active = try read(id, c)
        XCTAssertEqual(active.duration(at: sample(20, wall: -3600)).seconds, 20)
        let cold = UUID()
        // Reopening in a consistent clock epoch, then changing wall time, keeps the launch decision.
        var recovered = sample(40, wall: -3600, process: cold)
        recovered.launchWall = sample(20).wall; recovered.launchNanoseconds = sample(20).nanoseconds
        XCTAssertEqual(active.duration(at: recovered).seconds, 40)
        recovered = sample(40, wall: 7200, process: cold)
        recovered.launchWall = sample(20).wall; recovered.launchNanoseconds = sample(20).nanoseconds
        XCTAssertEqual(active.duration(at: recovered).seconds, 40)
        recovered.launchWall = sample(20, wall: 7200).wall
        recovered = .init(wall: sample(40).wall, nanoseconds: sample(40).nanoseconds, processID: cold,
            launchWall: recovered.launchWall, launchNanoseconds: sample(20).nanoseconds)
        XCTAssertTrue(active.duration(at: recovered).needsReview)

        XCTAssertEqual(active.duration(at: sample(20, process: cold)).seconds, 20)
        XCTAssertNil(active.duration(at: sample(20, wall: 7200, process: cold)).seconds)
        XCTAssertTrue(active.duration(at: sample(-1, process: cold)).needsReview)
        try ExecutionWriter.pause(active, at: sample(20, wall: -3600, process: cold), in: c.mainContext)
        let uncertain = try read(id, c)
        XCTAssertNil(uncertain.intervals.first?.elapsed)
        XCTAssertEqual(uncertain.intervals.first?.endedAt, sample(20, wall: -3600).wall)
        XCTAssertEqual(uncertain.intervals.first?.endNanoseconds, sample(20).nanoseconds)
        try ExecutionWriter.start(uncertain, at: sample(30, process: cold), in: c.mainContext)
        try ExecutionWriter.complete(read(id, c), at: sample(40, process: cold), in: c.mainContext)
        let complete = try read(id, c)
        XCTAssertNil(complete.duration(at: sample(50)).seconds)
        XCTAssertEqual(complete.duration(at: sample(50)).knownSeconds, 10)
        var draft = CompletionDraft(complete); draft.minutes = "1"
        try ExecutionWriter.edit(complete, draft: draft, today: day, in: c.mainContext)
        let corrected = try read(id, c)
        XCTAssertEqual(corrected.duration(at: sample(50)).seconds, 60)
        XCTAssertEqual(corrected.intervals, complete.intervals)
        var dateOnly = CompletionDraft(corrected); dateOnly.performedOn = day.adding(days: -1)
        try ExecutionWriter.edit(corrected, draft: dateOnly, today: day, in: c.mainContext)
        let dateEdited = try read(id, c)
        XCTAssertEqual(dateEdited.duration(at: sample(50)).seconds, 60)
        var clear = CompletionDraft(dateEdited); clear.minutes = ""
        try ExecutionWriter.edit(dateEdited, draft: clear, today: day, in: c.mainContext)
        XCTAssertTrue(try read(id, c).duration(at: sample(50)).needsReview)
    }

    func testRunningRestMoveSkipAtomicFailuresKeepIntervalsAndRestoreSameIdentity() throws {
        let (c, ids) = try fixture(3)
        try ExecutionWriter.start(read(ids[0], c), at: sample(0), in: c.mainContext)
        try ExecutionWriter.complete(read(ids[2], c), at: sample(0), in: c.mainContext)
        let before = try ids.map { try read($0, c) }
        let sources = before.filter { $0.occurrence.isUnfinished }.map(\.occurrence)
        XCTAssertThrowsError(try PlanWriter.rest(sources, today: day, in: c.mainContext, at: sample(15), save: { _ in throw Failure.disk }))
        XCTAssertEqual(try ids.map { try read($0, c) }, before)
        try PlanWriter.rest(sources, today: day, in: c.mainContext, at: sample(15))
        try PlanWriter.rest(sources, today: day, in: c.mainContext, at: sample(100))
        let rested = try read(ids[0], c)
        XCTAssertEqual(rested.occurrence.status, .skipped); XCTAssertEqual(rested.duration(at: sample(100)).seconds, 15)
        XCTAssertEqual(try read(ids[2], c), before[2])
        try PlanWriter.move(rested.occurrence, to: day.adding(days: 1), time: nil, restore: true, in: c.mainContext)
        let restored = try read(ids[0], c)
        XCTAssertEqual(restored.occurrence.status, .paused); XCTAssertEqual(restored.intervals, rested.intervals)
        try ExecutionWriter.start(restored, at: sample(100), in: c.mainContext)
        let running = try read(ids[0], c)
        XCTAssertThrowsError(try PlanWriter.move(running.occurrence, to: day.adding(days: 7), time: nil, in: c.mainContext, at: sample(105), save: { _ in throw Failure.disk }))
        XCTAssertEqual(try read(ids[0], c), running)
        try PlanWriter.move(running.occurrence, to: day.adding(days: 7), time: nil, in: c.mainContext, at: sample(105))
        let moved = try read(ids[0], c)
        XCTAssertEqual(moved.occurrence.status, .paused); XCTAssertEqual(moved.duration(at: sample(500)).seconds, 20)
        try ExecutionWriter.start(moved, at: sample(110), in: c.mainContext)
        try PlanWriter.skip(read(ids[0], c).occurrence, in: c.mainContext, at: sample(112))
        XCTAssertEqual(try read(ids[0], c).duration(at: sample(500)).seconds, 22)
    }

    func testMinutesValidationPreservesRawAndLargeFiniteDisplayDoesNotTrap() throws {
        let (c, ids) = try fixture(1)
        let source = try read(ids[0], c)
        for text in ["-1", "NaN", "Infinity", "1e500", String(repeating: "9", count: 400), "1.2.3"] {
            var draft = CompletionDraft(source); draft.minutes = text
            XCTAssertThrowsError(try draft.manualSeconds()); XCTAssertEqual(draft.minutes, text)
        }
        var draft = CompletionDraft(source); draft.minutes = "0.125"
        XCTAssertEqual(try draft.manualSeconds(), 7.5)
        XCTAssertFalse(RecordedDuration.timerLabel(Double.greatestFiniteMagnitude).isEmpty)
        XCTAssertEqual(RecordedDuration.timerLabel(3661.5), "1:01:01")
    }
}
