import XCTest

final class NotificationUITests: XCTestCase {
    @MainActor
    func testExplicitPermissionIndependentSettingsAndDefaultTimeSelection() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["설정"].waitForExistence(timeout: 10))
        XCTAssertFalse(XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch.exists,
                       "Launching must never ask notification permission")
        app.tabBars.buttons["설정"].tap()
        let planning = app.switches["notifications.planning"]
        XCTAssertTrue(planning.waitForExistence(timeout: 5))
        // The suite may follow earlier app-use tests; switch only the dedicated notification setting.
        if planning.value as? String == "1" { tapSwitch(planning, in: app) }
        tapSwitch(planning, in: app)
        let explain = app.buttons["알림 켜기"]
        XCTAssertTrue(explain.waitForExistence(timeout: 3)); explain.tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let permission = springboard.alerts.firstMatch
        if permission.waitForExistence(timeout: 3) {
            let allow = permission.buttons["허용"].exists ? permission.buttons["허용"] : permission.buttons["Allow"]
            XCTAssertTrue(allow.exists); allow.tap()
        }
        XCTAssertTrue(app.staticTexts["iPhone 알림이 허용되어 있어요."].waitForExistence(timeout: 5))
        let execution = app.switches["notifications.execution"]
        XCTAssertTrue(execution.exists)
        if execution.value as? String != "1" {
            tapSwitch(execution, in: app); XCTAssertTrue(explain.waitForExistence(timeout: 3)); explain.tap()
        }
        let choose = app.buttons["notifications.defaultTime"]
        XCTAssertTrue(choose.waitForExistence(timeout: 5)); reveal(choose, in: app); choose.tap()
        XCTAssertTrue(app.navigationBars["알림 시각"].waitForExistence(timeout: 3))
        app.buttons["선택"].tap()
        XCTAssertTrue(app.navigationBars["설정"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.navigationBars["알림 시각"].exists)
        tapSwitch(execution, in: app)
        let off = NSPredicate(format: "value == '0'")
        expectation(for: off, evaluatedWith: execution)
        waitForExpectations(timeout: 5)
        XCTAssertEqual(planning.value as? String, "1", "Execution OFF must preserve the independent planning reminder")
        let capture = XCTAttachment(screenshot: app.screenshot()); capture.name = "notification-settings-allowed"; capture.lifetime = .keepAlways; add(capture)
    }
    @MainActor private func tapSwitch(_ row: XCUIElement, in app: XCUIApplication) {
        let control = row.switches.firstMatch
        reveal(control, in: app)
        XCTAssertTrue(control.exists, app.debugDescription)
        control.tap()
    }
    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<10 {
            let top = app.navigationBars.firstMatch.frame.maxY, bottom = app.tabBars.firstMatch.frame.minY
            if element.exists, element.isHittable, element.frame.minY >= top, element.frame.maxY <= bottom { return }
            if element.exists && element.frame.minY < top { app.collectionViews.firstMatch.swipeDown() }
            else { app.collectionViews.firstMatch.swipeUp() }
        }
        XCTFail("Control did not enter the visible Form: \(element)")
    }

}
