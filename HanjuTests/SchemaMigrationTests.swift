import Foundation
import SwiftData
import XCTest
@testable import Hanju

@MainActor
final class SchemaMigrationTests: XCTestCase {
    func testRealV1DiskStoreMigratesToV2AndReopensWithAllRoutineValues() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appending(path: "v1-fixture.store")
        let id = UUID()
        let timestamp = Date(timeIntervalSince1970: 1_700_000_000)
        try autoreleasepool { try writeV1Fixture(url: url, id: id, date: timestamp) }
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        try autoreleasepool { try migrateAndAddPlan(url: url, id: id, date: timestamp) }
        let reopened = try PersistenceStore.makeContainer(storeURL: url)
        try verifyRoutine(in: reopened, id: id, date: timestamp)
        XCTAssertEqual(try reopened.mainContext.fetchCount(FetchDescriptor<WeekPlan>()), 1)
        let emptyURL = directory.appending(path: "empty-v1.store")
        try autoreleasepool {
            let schema = Schema(versionedSchema: HanjuSchemaV1.self)
            let config = ModelConfiguration(schema: schema, url: emptyURL, cloudKitDatabase: .none)
            let emptyV1 = try ModelContainer(for: schema, configurations: [config])
            try emptyV1.mainContext.save()
        }
        let emptyV2 = try PersistenceStore.makeContainer(storeURL: emptyURL)
        XCTAssertEqual(try emptyV2.mainContext.fetchCount(FetchDescriptor<RoutineTemplate>()), 0)
        XCTAssertEqual(try emptyV2.mainContext.fetchCount(FetchDescriptor<WeekPlan>()), 0)
        let rows = try reopened.mainContext.fetch(FetchDescriptor<PlannedOccurrence>())
        XCTAssertEqual(rows.count, 1)
        let active = try XCTUnwrap(reopened.mainContext.fetch(FetchDescriptor<RoutineTemplate>()).first { !$0.isArchived })
        XCTAssertEqual(rows.first?.routineID, active.id)
        XCTAssertEqual(rows.first?.nameSnapshot, "V1 원문")
    }
    private func writeV1Fixture(url: URL, id: UUID, date: Date) throws {
        let schema = Schema(versionedSchema: HanjuSchemaV1.self)
        let configuration = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let model = HanjuSchemaV1.RoutineTemplate(name: "V1 원문", id: id, now: date)
        model.category = "공부"; model.expectedMinutes = 25; model.weeklyFrequency = 9
        model.preferredWeekdays = [1, 7]; model.note = "\n메모 원문 "; model.firstAction = "펼치기"
        model.isArchived = true; model.updatedAt = date.addingTimeInterval(100)
        container.mainContext.insert(model)
        container.mainContext.insert(HanjuSchemaV1.RoutineTemplate(name: "선택값 없는 루틴", now: date))
        try container.mainContext.save()
    }
    private func migrateAndAddPlan(url: URL, id: UUID, date: Date) throws {
        let container = try PersistenceStore.makeContainer(storeURL: url)
        try verifyRoutine(in: container, id: id, date: date)
        XCTAssertEqual(try container.mainContext.fetchCount(FetchDescriptor<WeekPlan>()), 0)
        XCTAssertEqual(try container.mainContext.fetchCount(FetchDescriptor<PlannedOccurrence>()), 0)
        let day = try XCTUnwrap(LocalDate(year: 2026, month: 10, day: 5))
        let active = try XCTUnwrap(container.mainContext.fetch(FetchDescriptor<RoutineTemplate>()).first { !$0.isArchived })
        let entry = PlanDraft.Entry(routineID: active.id, name: "V1 원문", expectedMinutes: 25, firstAction: "펼치기", day: day)
        try PlanWriter.confirm(PlanDraft(week: day, entries: [entry]), in: container.mainContext)
    }
    private func verifyRoutine(in container: ModelContainer, id: UUID, date: Date) throws {
        let rows = try container.mainContext.fetch(FetchDescriptor<RoutineTemplate>())
        let model = try XCTUnwrap(rows.first { $0.id == id })
        let empty = try XCTUnwrap(rows.first { $0.id != id })
        XCTAssertEqual(empty.name, "선택값 없는 루틴"); XCTAssertFalse(empty.isArchived)
        XCTAssertNil(empty.category); XCTAssertNil(empty.expectedMinutes); XCTAssertNil(empty.weeklyFrequency)
        XCTAssertNil(empty.note); XCTAssertNil(empty.firstAction); XCTAssertEqual(empty.preferredWeekdays, [])
        XCTAssertEqual(rows.count, 2); XCTAssertEqual(model.id, id); XCTAssertEqual(model.name, "V1 원문")
        XCTAssertEqual(model.category, "공부"); XCTAssertEqual(model.expectedMinutes, 25)
        XCTAssertEqual(model.weeklyFrequency, 9); XCTAssertEqual(model.preferredWeekdays, [1, 7])
        XCTAssertEqual(model.note, "\n메모 원문 "); XCTAssertEqual(model.firstAction, "펼치기")
        XCTAssertTrue(model.isArchived); XCTAssertEqual(model.createdAt, date)
        XCTAssertEqual(model.updatedAt, date.addingTimeInterval(100))
    }
}
