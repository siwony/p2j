import Foundation
import SwiftData
import XCTest
@testable import Hanju

final class RoutineLibraryTests: XCTestCase {
    private enum Failure: Error { case diskFull }

    @MainActor
    func testAllOptionalFieldsEditArchiveRestoreAndReopen() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appending(path: "routines.store")
        let draft = RoutineDraft(name: "  Read  ", category: "공부", expectedMinutesText: "25", weeklyFrequencyText: "9", preferredWeekdays: [1, 7], note: "  keep spacing\nsecond line", firstAction: "Open book")
        let createdAt = try exerciseStore(url: url, draft: draft)
        let reopened = try PersistenceStore.makeContainer(storeURL: url)
        let rows = try RoutineWriter.fetch(in: reopened.mainContext, archived: false)
        let row = try XCTUnwrap(rows.first)
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(row.id, draft.id)
        XCTAssertEqual(row.createdAt, createdAt)
        XCTAssertEqual(row.draft.name, "Updated")
        XCTAssertEqual(row.draft.category, "공부")
        XCTAssertEqual(row.draft.expectedMinutesText, "25")
        XCTAssertEqual(row.draft.weeklyFrequencyText, "9")
        XCTAssertEqual(row.draft.preferredWeekdays, [1, 7])
        XCTAssertEqual(row.draft.note, draft.note)
        XCTAssertEqual(row.draft.firstAction, draft.firstAction)
    }

    @MainActor
    private func exerciseStore(url: URL, draft: RoutineDraft) throws -> Date {
        let container = try PersistenceStore.makeContainer(storeURL: url)
        try RoutineWriter.persist(draft, updating: false, in: container.mainContext)
        var original = try XCTUnwrap(RoutineWriter.fetch(in: container.mainContext, archived: false).first)
        let createdAt = original.createdAt
        var changed = original.draft
        changed.name = "Updated"
        try RoutineWriter.persist(changed, updating: true, in: container.mainContext)
        original = try XCTUnwrap(RoutineWriter.fetch(in: container.mainContext, archived: false).first)
        XCTAssertEqual(original.draft.name, "Updated")
        try RoutineWriter.setArchived(true, id: draft.id, in: container.mainContext)
        XCTAssertTrue(try RoutineWriter.fetch(in: container.mainContext, archived: false).isEmpty)
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: true).first?.id, draft.id)
        try RoutineWriter.setArchived(false, id: draft.id, in: container.mainContext)
        XCTAssertTrue(try RoutineWriter.fetch(in: container.mainContext, archived: true).isEmpty)
        return createdAt
    }

    @MainActor
    func testInvalidNumbersPreserveOriginalTextAndDoNotInsert() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        for invalid in ["0", "-1", "1.5", "abc", "999999999999999999999999999"] {
            for field in [RoutineDraft.Field.expectedMinutes, .weeklyFrequency] {
                var draft = RoutineDraft(name: "Original text")
                if field == .expectedMinutes { draft.expectedMinutesText = invalid }
                else { draft.weeklyFrequencyText = invalid }
                let original = draft
                XCTAssertThrowsError(try RoutineWriter.persist(draft, updating: false, in: container.mainContext))
                XCTAssertEqual(draft, original)
            }
        }
        XCTAssertTrue(try RoutineWriter.fetch(in: container.mainContext, archived: false).isEmpty)
        let blank = RoutineDraft(name: "Nil values", expectedMinutesText: "  ", weeklyFrequencyText: "\n")
        try RoutineWriter.persist(blank, updating: false, in: container.mainContext)
        let stored = try XCTUnwrap(container.mainContext.fetch(FetchDescriptor<RoutineTemplate>()).first)
        XCTAssertNil(stored.expectedMinutes)
        XCTAssertNil(stored.weeklyFrequency)
    }

    @MainActor
    func testFailedEditAndArchiveLeavePersistentValuesAndOtherDraftAlone() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let draft = RoutineDraft(name: "Saved", note: "Original note")
        try RoutineWriter.persist(draft, updating: false, in: container.mainContext)
        let before = try XCTUnwrap(RoutineWriter.fetch(in: container.mainContext, archived: false).first)
        let unrelated = RoutineTemplate(name: "Uncommitted other draft")
        container.mainContext.insert(unrelated)
        var changed = before.draft
        changed.name = "  New name  "
        changed.note = "  preserved\nraw text "
        XCTAssertThrowsError(try RoutineWriter.persist(changed, updating: true, in: container.mainContext) { _ in throw Failure.diskFull })
        XCTAssertEqual(changed.name, "  New name  ")
        XCTAssertEqual(changed.note, "  preserved\nraw text ")
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: false).first, before)
        XCTAssertTrue(container.mainContext.insertedModelsArray.contains(where: { ($0 as? RoutineTemplate)?.id == unrelated.id }))
        XCTAssertThrowsError(try RoutineWriter.setArchived(true, id: draft.id, in: container.mainContext) { _ in throw Failure.diskFull })
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: false).first, before)
        XCTAssertTrue(try RoutineWriter.fetch(in: container.mainContext, archived: true).isEmpty)
        try RoutineWriter.persist(changed, updating: true, in: container.mainContext)
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: false).first?.draft.name, "New name")
    }

    @MainActor
    func testCreateAndArchiveRetriesAreIdempotentAndOptionalFieldsCanBeCleared() throws {
        let container = try PersistenceStore.makeContainer(inMemory: true)
        let draft = RoutineDraft(name: "One", category: "생활", expectedMinutesText: "10", weeklyFrequencyText: "2", preferredWeekdays: [3], note: "Note", firstAction: "Start")
        try RoutineWriter.persist(draft, updating: false, in: container.mainContext)
        try RoutineWriter.persist(draft, updating: false, in: container.mainContext)
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: false).count, 1)
        try RoutineWriter.setArchived(true, id: draft.id, in: container.mainContext)
        let archived = try XCTUnwrap(RoutineWriter.fetch(in: container.mainContext, archived: true).first)
        try RoutineWriter.setArchived(true, id: draft.id, in: container.mainContext)
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: true).first, archived)
        XCTAssertThrowsError(try RoutineWriter.setArchived(false, id: draft.id, in: container.mainContext) { _ in throw Failure.diskFull })
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: true).first, archived)
        try RoutineWriter.setArchived(false, id: draft.id, in: container.mainContext)
        XCTAssertThrowsError(try RoutineWriter.persist(RoutineDraft(name: "Missing"), updating: true, in: container.mainContext))
        XCTAssertEqual(try RoutineWriter.fetch(in: container.mainContext, archived: false).count, 1)
        try RoutineWriter.persist(RoutineDraft(id: draft.id, name: "One"), updating: true, in: container.mainContext)
        let cleared = try XCTUnwrap(RoutineWriter.fetch(in: container.mainContext, archived: false).first)
        XCTAssertNil(cleared.draft.category)
        XCTAssertEqual(cleared.draft.expectedMinutesText, "")
        XCTAssertEqual(cleared.draft.weeklyFrequencyText, "")
        XCTAssertTrue(cleared.draft.preferredWeekdays.isEmpty)
        XCTAssertEqual(cleared.draft.note, "")
        XCTAssertEqual(cleared.draft.firstAction, "")
    }

    func testRevertingEveryDraftFieldRestoresCleanEquality() {
        let original = RoutineDraft(name: "Saved")
        var edited = original
        edited.name = "Changed"
        edited.category = "공부"
        edited.expectedMinutesText = "10"
        edited.preferredWeekdays = [1]
        XCTAssertNotEqual(edited, original)
        edited.name = original.name
        edited.category = original.category
        edited.expectedMinutesText = original.expectedMinutesText
        edited.preferredWeekdays = original.preferredWeekdays
        XCTAssertEqual(edited, original)
    }
}
