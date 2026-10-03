import XCTest

final class RoutineLibraryUITests: XCTestCase {
    @MainActor
    func testLibraryCreationSurvivesRelaunch() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        try openLibrary(in: app)
        let name = "Routine \(UUID().uuidString.prefix(8))"
        let input = try openEditor(in: app)
        input.tap()
        input.typeText(name)

        let save = app.buttons["저장"]
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        save.tap()
        XCTAssertTrue(routineRow(name, in: app).waitForExistence(timeout: 5))

        app.terminate()
        app.launch()
        try openLibrary(in: app)
        reveal(routineRow(name, in: app), in: app)
        XCTAssertTrue(routineRow(name, in: app).waitForExistence(timeout: 5))
    }

    @MainActor
    func testDraftCancellationKeepsThenDiscardsInput() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        try openLibrary(in: app)
        let name = "Draft \(UUID().uuidString.prefix(8))"
        let input = try openEditor(in: app)
        input.tap()
        input.typeText(name)

        app.buttons["취소"].tap()
        let keepEditing = app.buttons["계속 편집"]
        XCTAssertTrue(keepEditing.waitForExistence(timeout: 5), app.debugDescription)
        keepEditing.tap()
        XCTAssertEqual(input.value as? String, name)

        app.buttons["취소"].tap()
        let discard = app.buttons["변경 버리기"]
        XCTAssertTrue(discard.waitForExistence(timeout: 5))
        discard.tap()
        XCTAssertTrue(app.navigationBars["루틴함"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts[name].exists)

        let freshInput = try openEditor(in: app)
        XCTAssertNotEqual(freshInput.value as? String, name)
        app.buttons["취소"].tap()
    }

    @MainActor
    func testDirtySwipeKeepsInputThenDiscardsAndCleanSwipeDismisses() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        try openLibrary(in: app)
        let name = "Swipe \(UUID().uuidString.prefix(6))"
        let input = try openEditor(in: app)
        input.typeText(name)
        finishInput(in: app)
        swipeEditor(in: app, title: "새 루틴")
        let keep = app.buttons["계속 편집"]
        XCTAssertTrue(keep.waitForExistence(timeout: 5), app.debugDescription)
        keep.tap()
        XCTAssertEqual(input.value as? String, name)
        swipeEditor(in: app, title: "새 루틴")
        XCTAssertTrue(app.buttons["변경 버리기"].waitForExistence(timeout: 5))
        app.buttons["변경 버리기"].tap()
        XCTAssertTrue(app.navigationBars["루틴함"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts[name].exists)

        _ = try openEditor(in: app)
        finishInput(in: app)
        swipeEditor(in: app, title: "새 루틴")
        XCTAssertTrue(app.navigationBars["루틴함"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.navigationBars["새 루틴"].exists)
        _ = try openEditor(in: app)
        app.buttons["취소"].tap()
    }

    @MainActor
    func testOptionalFieldsImmediateEditAndDirtyArchiveRestore() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        try openLibrary(in: app)
        let name = "Details \(UUID().uuidString.prefix(6))"
        let input = try openEditor(in: app)
        input.typeText(name)
        finishInput(in: app)
        app.buttons["routine.category"].tap()
        app.buttons["공부"].tap()
        try enter("25", id: "routine.expectedMinutes", in: app)
        try enter("9", id: "routine.weeklyFrequency", in: app)
        try enter("Open the book", id: "routine.firstAction", in: app)
        try enter("Keep this note", id: "routine.note", in: app)
        reveal(app.buttons["선호 요일 (선택)"], in: app, upward: false)
        app.buttons["선호 요일 (선택)"].tap()
        app.buttons["routine.weekday.1"].tap()
        reveal(app.buttons["routine.weekday.7"], in: app)
        app.buttons["routine.weekday.7"].tap()
        app.buttons["저장"].tap()
        let row = routineRow(name, in: app)
        reveal(row, in: app)
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        row.tap()
        reveal(app.textFields["routine.expectedMinutes"], in: app)
        XCTAssertEqual(app.textFields["routine.expectedMinutes"].value as? String, "25")
        reveal(app.textFields["routine.weeklyFrequency"], in: app)
        XCTAssertEqual(app.textFields["routine.weeklyFrequency"].value as? String, "9")
        let editScreenshot = XCTAttachment(screenshot: app.screenshot())
        editScreenshot.name = "Routine-editor-standard"
        editScreenshot.lifetime = .keepAlways
        add(editScreenshot)
        reveal(app.buttons["선호 요일 (선택)"], in: app)
        app.buttons["선호 요일 (선택)"].tap()
        XCTAssertEqual(app.buttons["routine.weekday.1"].value as? String, "선택됨")
        reveal(app.buttons["routine.weekday.7"], in: app)
        XCTAssertEqual(app.buttons["routine.weekday.7"].value as? String, "선택됨")
        reveal(app.buttons["선호 요일 (선택)"], in: app, upward: false)
        app.buttons["선호 요일 (선택)"].tap()
        try enter(" discarded", id: "routine.note", in: app)
        reveal(app.buttons["보관"], in: app)
        app.buttons["보관"].tap()
        XCTAssertTrue(app.buttons["변경 버리고 보관"].waitForExistence(timeout: 5))
        app.buttons["계속 편집"].tap()
        XCTAssertTrue((app.textFields["routine.note"].value as? String ?? "").contains("discarded"))
        app.buttons["보관"].tap()
        app.buttons["변경 버리고 보관"].tap()
        XCTAssertTrue(app.navigationBars["루틴함"].waitForExistence(timeout: 5))
        XCTAssertFalse(routineRow(name, in: app).exists)
        reveal(app.buttons["보관함"], in: app)
        app.buttons["보관함"].tap()
        let archived = routineRow(name, in: app)
        reveal(archived, in: app)
        archived.tap()
        let note = app.textFields["routine.note"]
        reveal(note, in: app)
        XCTAssertEqual(note.value as? String, "Keep this note")
        XCTAssertEqual(app.textFields["routine.firstAction"].value as? String, "Open the book")
        reveal(app.buttons["복원"], in: app)
        app.buttons["복원"].tap()
        XCTAssertTrue(app.navigationBars["보관함"].waitForExistence(timeout: 5))
        XCTAssertFalse(routineRow(name, in: app).exists)
        app.navigationBars["보관함"].buttons.firstMatch.tap()
        reveal(routineRow(name, in: app), in: app)
        XCTAssertTrue(routineRow(name, in: app).exists)
    }

    @MainActor
    func testCategoryChangeRemainsVisibleAndRevertedEditSwipesCleanly() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        try openLibrary(in: app)
        let name = "Category \(UUID().uuidString.prefix(6))"
        for suffix in ["", " other"] {
            let input = try openEditor(in: app)
            input.typeText(name + suffix)
            finishInput(in: app)
            app.buttons["routine.category"].tap()
            app.buttons["공부"].tap()
            app.buttons["저장"].tap()
        }
        reveal(app.buttons["routine.categoryFilter"], in: app, upward: false)
        app.buttons["routine.categoryFilter"].tap()
        app.buttons["공부"].tap()
        let row = routineRow(name, in: app, exact: true)
        reveal(row, in: app)
        row.tap()
        app.buttons["routine.category"].tap()
        app.buttons["생활"].tap()
        app.buttons["저장"].tap()
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        XCTAssertTrue(row.isHittable)
        XCTAssertFalse(routineRow(name + " other", in: app).exists)
        row.tap()
        app.buttons["routine.category"].tap()
        app.buttons["공부"].tap()
        app.buttons["routine.category"].tap()
        app.buttons["생활"].tap()
        swipeEditor(in: app, title: "루틴 편집")
        XCTAssertTrue(app.navigationBars["루틴함"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["변경 버리기"].exists)
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Routine-library-filtered"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    @MainActor
    func testInvalidNumericInputStaysUntilCorrected() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        try openLibrary(in: app)
        let name = "Number \(UUID().uuidString.prefix(6))"
        let input = try openEditor(in: app)
        input.typeText(name)
        finishInput(in: app)
        try enter("0", id: "routine.expectedMinutes", in: app)
        app.buttons["저장"].tap()
        XCTAssertTrue(app.staticTexts["routine.error"].waitForExistence(timeout: 5))
        let number = app.textFields["routine.expectedMinutes"]
        XCTAssertEqual(number.value as? String, "0")
        XCTAssertTrue(app.navigationBars["새 루틴"].exists)
        // Numeric input is trailing-aligned; tap after its last glyph rather than
        // the empty leading portion of the field before sending Backspace.
        number.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5)).tap()
        number.typeText(XCUIKeyboardKey.delete.rawValue + "5")
        XCTAssertEqual(number.value as? String, "5")
        finishInput(in: app)
        app.buttons["저장"].tap()
        XCTAssertTrue(routineRow(name, in: app).waitForExistence(timeout: 5))
        XCTAssertTrue(routineRow(name, in: app).label.contains("5분"))
    }

    @MainActor
    private func routineRow(_ name: String, in app: XCUIApplication, exact: Bool = false) -> XCUIElement {
        let comparison = exact ? "label == %@" : "label CONTAINS %@"
        return app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@ AND " + comparison, "routine.row.", name)).firstMatch
    }

    @MainActor
    private func enter(_ text: String, id: String, in app: XCUIApplication) throws {
        let field = app.textFields[id]
        reveal(field, in: app)
        XCTAssertTrue(field.exists, app.debugDescription)
        field.tap()
        field.typeText(text)
        finishInput(in: app)
    }

    @MainActor
    private func finishInput(in app: XCUIApplication) {
        if app.buttons["입력 완료"].exists { app.buttons["입력 완료"].tap() }
    }

    @MainActor
    private func reveal(_ element: XCUIElement, in app: XCUIApplication, upward: Bool = true) {
        for _ in 0..<8 {
            if element.exists && element.isHittable { return }
            if upward { app.collectionViews.firstMatch.swipeUp() }
            else { app.collectionViews.firstMatch.swipeDown() }
        }
    }

    @MainActor
    private func swipeEditor(in app: XCUIApplication, title: String) {
        let start = app.navigationBars[title].coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.85))
        start.press(forDuration: 0.1, thenDragTo: end)
    }

    @MainActor
    private func openLibrary(in app: XCUIApplication) throws {
        let tab = app.tabBars.buttons["루틴함"]
        XCTAssertTrue(tab.waitForExistence(timeout: 10))
        tab.tap()
        XCTAssertTrue(app.navigationBars["루틴함"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func openEditor(in app: XCUIApplication) throws -> XCUIElement {
        app.buttons["새 루틴"].tap()
        // A vertically expanding SwiftUI TextField can expose either native input type.
        let input = app.descendants(matching: .any).matching(NSPredicate(
            format: "label == %@ AND (elementType == %d OR elementType == %d)",
            "루틴 이름", XCUIElement.ElementType.textField.rawValue,
            XCUIElement.ElementType.textView.rawValue
        )).firstMatch
        XCTAssertTrue(input.waitForExistence(timeout: 5))
        return input
    }
}
