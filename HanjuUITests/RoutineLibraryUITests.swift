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
        XCTAssertTrue(app.staticTexts[name].waitForExistence(timeout: 5))

        app.terminate()
        app.launch()
        try openLibrary(in: app)
        XCTAssertTrue(app.staticTexts[name].waitForExistence(timeout: 5))
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
