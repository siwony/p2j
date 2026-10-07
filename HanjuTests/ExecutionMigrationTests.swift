import Foundation
import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class ExecutionMigrationTests: XCTestCase {
    func testActualV2DiskMigrationPreservesPlansAndRunningRecordReopensInV3() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appending(path: "v2.store")
        let day = try XCTUnwrap(LocalDate(year: 2026, month: 10, day: 5))
        let id = UUID(), routineID = UUID(), weekID = UUID(), processID = UUID()
        try autoreleasepool {
            let schema = Schema(versionedSchema: HanjuSchemaV2.self)
            let config = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)
            let c = try ModelContainer(for: schema, configurations: [config])
            let routine = RoutineTemplate(name: "이전 루틴", id: routineID)
            routine.isArchived = true; routine.note = "원문\n보존"
            c.mainContext.insert(routine)
            let week = HanjuSchemaV2.WeekPlan(mondayKey: day.key, id: weekID, now: day.pickerDate)
            week.calendarConnected = true; c.mainContext.insert(week)
            let occurrence = HanjuSchemaV2.PlannedOccurrence(id: id, weekID: weekID, routineID: routineID,
                name: "당시 이름", expectedMinutes: 25, firstAction: "펼치기", day: day, time: LocalTime(minutes: 540), now: day.pickerDate)
            c.mainContext.insert(occurrence); try c.mainContext.save()
        }
        try autoreleasepool {
            let c = try PersistenceStore.makeContainer(storeURL: url)
            XCTAssertEqual(try c.mainContext.fetchCount(FetchDescriptor<ExecutionRecord>()), 0)
            XCTAssertEqual(try c.mainContext.fetchCount(FetchDescriptor<ExecutionInterval>()), 0)
            let week = try XCTUnwrap(c.mainContext.fetch(FetchDescriptor<WeekPlan>()).first)
            XCTAssertEqual(week.id, weekID); XCTAssertTrue(week.calendarConnected)
            let source = try ExecutionWriter.snapshot(id, in: ModelContext(c))
            XCTAssertEqual(source.occurrence.name, "당시 이름"); XCTAssertEqual(source.occurrence.routineID, routineID)
            XCTAssertEqual(source.occurrence.expectedMinutes, 25); XCTAssertEqual(source.occurrence.firstAction, "펼치기")
            XCTAssertEqual(source.occurrence.time?.minutes, 540)
            try ExecutionWriter.start(source, at: .init(wall: day.pickerDate, nanoseconds: 100_000_000_000, processID: processID), in: c.mainContext)
        }
        try autoreleasepool {
            let c = try PersistenceStore.makeContainer(storeURL: url)
            let now = ExecutionClock.Sample(wall: day.pickerDate.addingTimeInterval(12), nanoseconds: 112_000_000_000, processID: UUID())
            let recorder = ExecutionRecorder(container: c, clock: { now })
            let active = try XCTUnwrap(recorder.active)
            XCTAssertEqual(active.id, id); XCTAssertEqual(active.occurrence.day, day)
            XCTAssertEqual(active.duration(at: now).seconds, 12)
            try recorder.complete(active)
            let completed = try recorder.read(id)
            XCTAssertEqual(completed.duration(at: now).seconds, 12)
            XCTAssertEqual(completed.intervals.first?.start.processID, processID)
            XCTAssertEqual(completed.intervals.first?.start.nanoseconds, 100_000_000_000)
        }
        let final = try PersistenceStore.makeContainer(storeURL: url)
        let stored = try ExecutionWriter.snapshot(id, in: ModelContext(final))
        XCTAssertEqual(stored.occurrence.status, .completed)
        XCTAssertEqual(stored.intervals.first?.elapsed, 12)
        let routine = try XCTUnwrap(final.mainContext.fetch(FetchDescriptor<RoutineTemplate>()).first)
        XCTAssertTrue(routine.isArchived); XCTAssertEqual(routine.note, "원문\n보존")
    }
    func testDetectedColdUncertaintySurvivesDiskReopenAndFailedFlagSavePreservesRunning() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appending(path: "recovery.store")
        let day = try XCTUnwrap(LocalDate(year: 2026, month: 10, day: 5))
        let id = UUID(), process = UUID()
        try autoreleasepool {
            let c = try PersistenceStore.makeContainer(storeURL: url)
            let routine = RoutineTemplate(name: "원문"); c.mainContext.insert(routine); try c.mainContext.save()
            let entry = PlanDraft.Entry(id: id, routineID: routine.id, name: "원문", expectedMinutes: nil, firstAction: nil, day: day)
            try PlanWriter.confirm(PlanDraft(week: day, entries: [entry]), in: c.mainContext)
            let source = try ExecutionWriter.snapshot(id, in: ModelContext(c))
            try ExecutionWriter.start(source, at: .init(wall: day.pickerDate, nanoseconds: 100_000_000_000, processID: process), in: c.mainContext)
        }
        try autoreleasepool {
            let c = try PersistenceStore.makeContainer(storeURL: url)
            let original = try ExecutionWriter.snapshot(id, in: ModelContext(c))
            let cold = ExecutionClock.Sample(wall: day.pickerDate.addingTimeInterval(7200), nanoseconds: 110_000_000_000, processID: UUID())
            enum Failure: Error { case disk }
            XCTAssertThrowsError(try ExecutionWriter.preserveRecoveryReview(at: cold, in: c.mainContext, save: { _ in throw Failure.disk }))
            XCTAssertEqual(try ExecutionWriter.snapshot(id, in: ModelContext(c)), original)
            try ExecutionWriter.preserveRecoveryReview(at: cold, in: c.mainContext)
            let detected = try ExecutionWriter.snapshot(id, in: ModelContext(c))
            XCTAssertTrue(try XCTUnwrap(detected.intervals.first).recoveryNeedsReview)
            XCTAssertEqual(detected.occurrence.status, .running)
            XCTAssertNil(detected.intervals.first?.endedAt)
            XCTAssertEqual(detected.intervals.first?.start, original.intervals.first?.start)
        }
        let c = try PersistenceStore.makeContainer(storeURL: url)
        let normal = ExecutionClock.Sample(wall: day.pickerDate.addingTimeInterval(20), nanoseconds: 120_000_000_000, processID: UUID())
        let recorder = ExecutionRecorder(container: c, clock: { normal })
        let active = try XCTUnwrap(recorder.active)
        XCTAssertTrue(active.duration(at: normal).needsReview)
        XCTAssertNil(active.duration(at: normal).seconds)
        try recorder.complete(active)
        let closed = try recorder.read(id)
        XCTAssertNil(closed.intervals.first?.elapsed)
        XCTAssertTrue(try XCTUnwrap(closed.intervals.first).recoveryNeedsReview)
        var correction = CompletionDraft(closed); correction.minutes = "2"
        try recorder.edit(closed, draft: correction)
        let corrected = try recorder.read(id)
        XCTAssertEqual(corrected.duration(at: normal).seconds, 120)
        XCTAssertEqual(corrected.intervals, closed.intervals)
    }

}
