import Foundation
import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class RecordsMigrationTests: XCTestCase {
    private let monday = LocalDate(year: 2026, month: 10, day: 5)!

    private struct Fixture {
        let routineID = UUID()
        let weekID = UUID()
        let occurrenceIDs = [UUID(), UUID(), UUID()]
        let processID = UUID()
        var occurrences: [OccurrenceSnapshot] = []
        var executions: [ExecutionSnapshot] = []
    }

    func testActualV1V2V3DiskStoresMigrateToV4WithoutInventingMoveHistory() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let versions: [any VersionedSchema.Type] = [HanjuSchemaV1.self, HanjuSchemaV2.self, HanjuSchemaV3.self]
        for (index, version) in versions.enumerated() {
            let url = directory.appending(path: "v\(index + 1).store")
            let fixture = try autoreleasepool { try writeFixture(version: version, number: index + 1, url: url) }
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
            try autoreleasepool {
                let migrated = try PersistenceStore.makeContainer(storeURL: url)
                try verifyFixture(fixture, number: index + 1, in: migrated)
                _ = try RecordsStore.saveMemo(week: monday, body: "  이전 후 메모\n원문\n", in: migrated.mainContext)
                _ = try RecordsStore.saveMemo(week: monday.adding(days: 7), body: "다음 주", in: migrated.mainContext)
            }
            try autoreleasepool {
                let reopened = try PersistenceStore.makeContainer(storeURL: url)
                try verifyFixture(fixture, number: index + 1, in: reopened)
                XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: reopened.mainContext).body, "  이전 후 메모\n원문\n")
                XCTAssertEqual(try RecordsStore.fetchMemo(week: monday.adding(days: 7), in: reopened.mainContext).body, "다음 주")
                _ = try RecordsStore.saveMemo(week: monday, body: "", in: reopened.mainContext)
            }
            try autoreleasepool {
                let reopened = try PersistenceStore.makeContainer(storeURL: url)
                XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: reopened.mainContext).body, "")
                XCTAssertEqual(try RecordsStore.fetchMemo(week: monday.adding(days: 7), in: reopened.mainContext).body, "다음 주")
                XCTAssertEqual(try reopened.mainContext.fetchCount(FetchDescriptor<WeeklyMemo>()), 2)
            }
        }
    }

    func testMemoFailureAndSuccessfulMoveEvidenceSurviveDiskReopen() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appending(path: "v4.store")
        let id = UUID()
        enum Failure: Error { case disk }
        try autoreleasepool {
            let container = try PersistenceStore.makeContainer(storeURL: url)
            let routine = RoutineTemplate(name: "당시 이름")
            container.mainContext.insert(routine)
            try container.mainContext.save()
            let entry = PlanDraft.Entry(id: id, routineID: routine.id, name: "당시 이름",
                                        expectedMinutes: nil, firstAction: nil, day: monday)
            try PlanWriter.confirm(PlanDraft(week: monday, entries: [entry]), in: container.mainContext)
            let source = try ExecutionWriter.snapshot(id, in: ModelContext(container))
            try PlanWriter.move(source.occurrence, to: monday.adding(days: 1), time: nil, in: container.mainContext)
            _ = try RecordsStore.saveMemo(week: monday, body: "저장된 원문", in: container.mainContext)
            XCTAssertThrowsError(try RecordsStore.saveMemo(week: monday, body: "저장 실패한 초안",
                in: container.mainContext, save: { _ in throw Failure.disk }))
        }
        try autoreleasepool {
            let reopened = try PersistenceStore.makeContainer(storeURL: url)
            XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: reopened.mainContext).body, "저장된 원문")
            let evidence = try reopened.mainContext.fetch(FetchDescriptor<OccurrenceDateMove>())
            XCTAssertEqual(evidence.count, 1)
            XCTAssertEqual(evidence.first?.occurrenceID, id)
            XCTAssertEqual(evidence.first?.fromDayKey, monday.key)
            XCTAssertEqual(evidence.first?.toDayKey, monday.adding(days: 1).key)
            let source = try ExecutionWriter.snapshot(id, in: ModelContext(reopened))
            let now = ExecutionClock.Sample(wall: monday.adding(days: 1).pickerDate,
                                            nanoseconds: 1_000_000_000, processID: UUID())
            try ExecutionWriter.complete(source, at: now, timeZone: .gmt, in: reopened.mainContext)
            XCTAssertEqual(try RecordsStore.fetch(week: monday, in: reopened.mainContext, at: now).movedOccurrenceIDs, [id])
            _ = try RecordsStore.saveMemo(week: monday, body: "저장 실패한 초안", in: reopened.mainContext)
        }
        let reopened = try PersistenceStore.makeContainer(storeURL: url)
        XCTAssertEqual(try RecordsStore.fetchMemo(week: monday, in: reopened.mainContext).body, "저장 실패한 초안")
    }

    private func writeFixture(version: any VersionedSchema.Type, number: Int, url: URL) throws -> Fixture {
        var fixture = Fixture()
        let schema = Schema(versionedSchema: version)
        let configuration = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        container.mainContext.autosaveEnabled = false
        let routine = HanjuSchemaV1.RoutineTemplate(name: "수정된 루틴 원본", id: fixture.routineID, now: monday.pickerDate)
        routine.isArchived = true
        routine.note = "  원본 메모\n"
        routine.category = "공부"
        routine.expectedMinutes = 25
        routine.weeklyFrequency = 3
        routine.preferredWeekdays = [1, 7]
        routine.firstAction = "펼치기"
        container.mainContext.insert(routine)
        if number >= 2 {
            let week = HanjuSchemaV2.WeekPlan(mondayKey: monday.key, id: fixture.weekID, now: monday.pickerDate)
            week.calendarConnected = true
            container.mainContext.insert(week)
            for (offset, id) in fixture.occurrenceIDs.enumerated() {
                let occurrence = HanjuSchemaV2.PlannedOccurrence(id: id, weekID: fixture.weekID,
                    routineID: fixture.routineID, name: "당시 이름 \(offset)", expectedMinutes: 10 + offset,
                    firstAction: "당시 첫 행동", day: monday.adding(days: offset),
                    time: LocalTime(minutes: 540 + offset), now: monday.pickerDate)
                if number == 3 {
                    occurrence.statusRaw = ["completed", "running", "skipped"][offset]
                    if offset == 2 { occurrence.statusBeforeSkip = "paused" }
                }
                container.mainContext.insert(occurrence)
            }
        }
        if number == 3 {
            for (offset, id) in fixture.occurrenceIDs.enumerated() {
                let record = HanjuSchemaV3.ExecutionRecord(occurrenceID: id)
                record.revision = 7 + offset
                if offset == 0 {
                    record.completedAt = monday.pickerDate.addingTimeInterval(50)
                    record.completionDayKey = monday.key
                    record.performedDayKey = monday.adding(days: -1).key
                    record.manualSeconds = 120.5
                    record.manualThroughSequence = 1
                }
                container.mainContext.insert(record)
                let start = ExecutionClock.Sample(wall: monday.pickerDate,
                                                  nanoseconds: 10_000_000_000, processID: fixture.processID)
                let interval = HanjuSchemaV3.ExecutionInterval(occurrenceID: id, sequence: 1, sample: start)
                if offset != 1 {
                    interval.endedAt = monday.pickerDate.addingTimeInterval(12.25)
                    interval.endNanoseconds = 22_250_000_000
                    interval.elapsedSeconds = 12.25
                } else {
                    interval.recoveryNeedsReview = true
                }
                container.mainContext.insert(interval)
            }
        }
        try container.mainContext.save()
        if number >= 2 {
            fixture.occurrences = try container.mainContext.fetch(FetchDescriptor<PlannedOccurrence>())
                .map(OccurrenceSnapshot.init).sorted { $0.id.uuidString < $1.id.uuidString }
        }
        if number == 3 {
            fixture.executions = try fixture.occurrenceIDs.map {
                try ExecutionWriter.snapshot($0, in: container.mainContext)
            }
        }
        return fixture
    }

    private func verifyFixture(_ fixture: Fixture, number: Int, in container: ModelContainer) throws {
        let context = ModelContext(container)
        let routine = try XCTUnwrap(context.fetch(FetchDescriptor<RoutineTemplate>()).first)
        XCTAssertEqual(routine.id, fixture.routineID)
        XCTAssertEqual(routine.name, "수정된 루틴 원본")
        XCTAssertTrue(routine.isArchived)
        XCTAssertEqual(routine.note, "  원본 메모\n")
        XCTAssertEqual(routine.category, "공부")
        XCTAssertEqual(routine.expectedMinutes, 25)
        XCTAssertEqual(routine.weeklyFrequency, 3)
        XCTAssertEqual(routine.preferredWeekdays, [1, 7])
        XCTAssertEqual(routine.firstAction, "펼치기")
        XCTAssertEqual(routine.createdAt, monday.pickerDate)
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<OccurrenceDateMove>()), 0)
        let occurrences = try context.fetch(FetchDescriptor<PlannedOccurrence>())
        let snapshots = try occurrences.map(OccurrenceSnapshot.init).sorted { $0.id.uuidString < $1.id.uuidString }
        XCTAssertEqual(snapshots, fixture.occurrences)
        let weeks = try context.fetch(FetchDescriptor<WeekPlan>())
        XCTAssertEqual(weeks.count, number >= 2 ? 1 : 0)
        if number >= 2 {
            XCTAssertEqual(weeks.first?.id, fixture.weekID)
            XCTAssertEqual(weeks.first?.mondayKey, monday.key)
            XCTAssertEqual(weeks.first?.calendarConnected, true)
            XCTAssertTrue(occurrences.allSatisfy { $0.weekID == fixture.weekID })
        }
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<ExecutionRecord>()), number == 3 ? 3 : 0)
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<ExecutionInterval>()), number == 3 ? 3 : 0)
        if number == 3 {
            let actual = try fixture.occurrenceIDs.map { try ExecutionWriter.snapshot($0, in: context) }
            XCTAssertEqual(actual, fixture.executions)
            XCTAssertEqual(try ExecutionWriter.active(in: context)?.id, fixture.occurrenceIDs[1])
            let now = ExecutionClock.Sample(wall: monday.pickerDate.addingTimeInterval(60),
                                            nanoseconds: 70_000_000_000, processID: UUID())
            let priorWeek = try RecordsStore.fetch(week: monday.adding(days: -1), in: context, at: now)
            XCTAssertEqual(priorWeek.completed.map(\.id), [fixture.occurrenceIDs[0]])
            XCTAssertEqual(priorWeek.timeSummary.totalSeconds, 120.5)
            XCTAssertTrue(priorWeek.movedOccurrenceIDs.isEmpty)
        }
    }
}
