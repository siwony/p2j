import Foundation
import SwiftData
import XCTest
@testable import Hanju

final class RoutinePersistenceTests: XCTestCase {
    @MainActor
    func testSaveAndReopenRetainsIdentityAndOptionalValues() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appending(path: "routines.store")
        let id = UUID()
        let created = Date(timeIntervalSince1970: 1_700_000_000)
        try writeRoutine(to: url, id: id, created: created)

        let reopened = try PersistenceStore.makeContainer(storeURL: url)
        let routines = try reopened.mainContext.fetch(FetchDescriptor<RoutineTemplate>())
        let routine = try XCTUnwrap(routines.first)
        XCTAssertEqual(routines.count, 1)
        XCTAssertEqual(routine.id, id)
        XCTAssertEqual(routine.name, "책상 정리")
        XCTAssertEqual(routine.createdAt, created)
        XCTAssertNil(routine.expectedMinutes)
        XCTAssertNil(routine.weeklyFrequency)
        XCTAssertTrue(routine.preferredWeekdays.isEmpty)
        XCTAssertFalse(routine.isArchived)
    }

    @MainActor
    private func writeRoutine(to url: URL, id: UUID, created: Date) throws {
        let container = try PersistenceStore.makeContainer(storeURL: url)
        container.mainContext.insert(RoutineTemplate(name: "책상 정리", id: id, now: created))
        try container.mainContext.save()
    }

    @MainActor
    func testInMemoryContainersDoNotShareData() throws {
        let first = try PersistenceStore.makeContainer(inMemory: true)
        let second = try PersistenceStore.makeContainer(inMemory: true)
        try RoutineWriter.create(from: RoutineDraft(name: "읽기"), in: first.mainContext)
        XCTAssertEqual(try first.mainContext.fetchCount(FetchDescriptor<RoutineTemplate>()), 1)
        XCTAssertEqual(try second.mainContext.fetchCount(FetchDescriptor<RoutineTemplate>()), 0)
    }

    @MainActor
    func testSaveFailurePreservesDraftAndRetryCreatesOnlyOneRoutine() throws {
        enum Failure: Error { case storageUnavailable }
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let draft = RoutineDraft(name: "  책상 정리  ")
        XCTAssertThrowsError(try RoutineWriter.create(from: draft, in: container.mainContext) {
            throw Failure.storageUnavailable
        })
        XCTAssertEqual(draft.name, "  책상 정리  ")
        XCTAssertEqual(try container.mainContext.fetchCount(FetchDescriptor<RoutineTemplate>()), 0)

        try RoutineWriter.create(from: draft, in: container.mainContext)
        let routines = try container.mainContext.fetch(FetchDescriptor<RoutineTemplate>())
        XCTAssertEqual(routines.count, 1)
        XCTAssertEqual(routines.first?.name, "책상 정리")
    }

    @MainActor
    func testBlankNameCannotCreateRoutine() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        XCTAssertThrowsError(try RoutineWriter.create(from: RoutineDraft(name: " \n "), in: container.mainContext))
        XCTAssertEqual(try container.mainContext.fetchCount(FetchDescriptor<RoutineTemplate>()), 0)
    }
}
