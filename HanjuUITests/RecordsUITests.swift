import XCTest

final class RecordsUITests: XCTestCase {
    @MainActor
    func testCompletionCorrectionMovesSameRecordBetweenWeeksAndUndoRecompleteRefreshes() throws {
        continueAfterFailure = false
        let app = application(); app.launch()
        let name = "Record \(UUID().uuidString.prefix(6))"
        createTodayPlan(name, in: app)
        app.tabBars.buttons["오늘"].tap()
        let planned = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(planned.buttons["이미 했어요"], in: app)
        planned.buttons["이미 했어요"].tap()
        app.tabBars.buttons["기록"].tap()
        let row = completedRow(name, in: app)
        reveal(row, in: app)
        XCTAssertTrue(row.staticTexts["시간 미기록"].exists, app.debugDescription)
        let recordID = row.identifier
        XCTAssertTrue(recordID.hasPrefix("records.row."))
        row.tap()
        XCTAssertTrue(app.navigationBars["실행 기록"].waitForExistence(timeout: 5))
        let minutes = app.textFields["execution.minutes"]
        minutes.tap(); minutes.typeText("0")
        app.buttons["저장"].tap()
        reveal(row, in: app)
        XCTAssertEqual(row.identifier, recordID)
        XCTAssertTrue(row.staticTexts["0분 기록"].exists)
        row.tap()
        let now = Date(), calendar = Calendar(identifier: .gregorian)
        let weekday = (calendar.component(.weekday, from: now) + 5) % 7 + 1
        let priorSunday = try XCTUnwrap(calendar.date(byAdding: .day, value: -weekday, to: now))
        pickDate(priorSunday, from: now, in: app)
        app.buttons["저장"].tap()
        XCTAssertTrue(app.navigationBars["기록"].waitForExistence(timeout: 5))
        XCTAssertFalse(row.exists)
        let previous = app.collectionViews.buttons["지난주"]
        reveal(previous, in: app, upward: false); previous.tap()
        reveal(row, in: app)
        XCTAssertEqual(row.identifier, recordID)
        XCTAssertTrue(row.staticTexts["0분 기록"].exists)
        row.tap()
        XCTAssertEqual(app.datePickers.firstMatch.buttons.firstMatch.value as? String,
            "\(calendar.component(.year, from: priorSunday)). \(calendar.component(.month, from: priorSunday)). \(calendar.component(.day, from: priorSunday)).")
        reveal(app.buttons["완료 취소"], in: app); app.buttons["완료 취소"].tap()
        app.sheets["완료 표시를 취소할까요?"].buttons["완료 취소"].tap()
        XCTAssertTrue(app.navigationBars["기록"].waitForExistence(timeout: 5))
        XCTAssertFalse(row.exists)
        app.tabBars.buttons["오늘"].tap()
        reveal(planned.buttons["이미 했어요"], in: app)
        planned.buttons["이미 했어요"].tap()
        app.tabBars.buttons["기록"].tap()
        XCTAssertFalse(row.exists) // The Records tab keeps its selected prior week.
        let current = app.collectionViews.buttons["이번 주"]
        reveal(current, in: app, upward: false); current.tap()
        reveal(row, in: app)
        XCTAssertEqual(row.identifier, recordID)
        XCTAssertTrue(row.staticTexts["0분 기록"].exists)
        let count = app.staticTexts.matching(NSPredicate(
            format: "identifier BEGINSWITH %@ AND label == %@", "records.count.", name + ", 1회")).firstMatch
        reveal(count, in: app)
        XCTAssertTrue(count.isHittable, app.debugDescription)
        XCTAssertEqual(count.label, name + ", 1회")
        let capture = XCTAttachment(screenshot: app.screenshot()); capture.name = "Records-counts"; capture.lifetime = .keepAlways; add(capture)
    }

    @MainActor
    func testMemoWeekTabAndBackgroundFlushRelaunchAndPlanningCaller() throws {
        continueAfterFailure = false
        let app = application(); app.launch()
        let currentText = "이번 주 메모 \(UUID().uuidString.prefix(6))"
        let priorText = "지난주 메모 \(UUID().uuidString.prefix(6))"
        let backgroundText = "배경 전환 \(UUID().uuidString.prefix(6))"
        app.tabBars.buttons["기록"].tap()
        let memo = app.textViews["records.memo"]
        reveal(memo, in: app); memo.tap(); memo.typeText(currentText)
        // End native editing before tapping the tab bar covered by the software keyboard.
        app.buttons["입력 완료"].tap()
        XCTAssertTrue(app.keyboards.firstMatch.waitForNonExistence(timeout: 5))
        let settingsTab = app.tabBars.buttons["설정"], recordsTab = app.tabBars.buttons["기록"]
        XCTAssertTrue(settingsTab.isHittable, app.debugDescription)
        settingsTab.tap()
        XCTAssertTrue(settingsTab.isSelected)
        XCTAssertTrue(recordsTab.isHittable)
        recordsTab.tap()
        XCTAssertTrue(recordsTab.isSelected)
        reveal(memo, in: app)
        XCTAssertTrue((memo.value as? String)?.contains(currentText) == true)
        let previous = app.collectionViews.buttons["지난주"]
        reveal(previous, in: app, upward: false); previous.tap()
        reveal(memo, in: app); memo.tap(); memo.typeText(priorText)
        app.buttons["입력 완료"].tap()
        let current = app.collectionViews.buttons["이번 주"]
        reveal(current, in: app, upward: false); current.tap()
        reveal(memo, in: app)
        XCTAssertTrue((memo.value as? String)?.contains(currentText) == true)
        XCTAssertFalse((memo.value as? String)?.contains(priorText) == true)
        memo.tap(); memo.typeText("\n" + backgroundText)
        XCUIDevice.shared.press(.home); app.activate()
        app.terminate(); app.launch(); app.tabBars.buttons["기록"].tap()
        reveal(memo, in: app)
        XCTAssertTrue((memo.value as? String)?.contains(currentText) == true)
        XCTAssertTrue((memo.value as? String)?.contains(backgroundText) == true)
        let nextPlan = app.buttons["records.planNextWeek"]
        reveal(nextPlan, in: app); nextPlan.tap()
        XCTAssertTrue(app.navigationBars["주간 계획"].waitForExistence(timeout: 5))
        let preview = app.staticTexts["week.previousMemo"]
        reveal(preview, in: app)
        XCTAssertTrue(preview.label.contains(currentText), app.debugDescription)
        app.buttons["취소"].tap()
        XCTAssertTrue(app.tabBars.buttons["기록"].isSelected)
        XCTAssertTrue(app.navigationBars["기록"].exists)
        reveal(previous, in: app, upward: false); previous.tap()
        reveal(memo, in: app)
        XCTAssertTrue((memo.value as? String)?.contains(priorText) == true)
        let pastPlan = app.buttons["지난 계획 보기"]
        reveal(pastPlan, in: app); pastPlan.tap()
        XCTAssertTrue(app.tabBars.buttons["이번 주"].isSelected)
        XCTAssertTrue(app.navigationBars["이번 주"].waitForExistence(timeout: 5))
        app.tabBars.buttons["기록"].tap()
        reveal(memo, in: app)
        XCTAssertTrue((memo.value as? String)?.contains(priorText) == true)
        let capture = XCTAttachment(screenshot: app.screenshot()); capture.name = "Records-weekly-memo"; capture.lifetime = .keepAlways; add(capture)
    }

    @MainActor private func application() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(ko)", "-AppleLocale", "ko_KR"]
        return app
    }
    @MainActor private func completedRow(_ name: String, in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@ AND label CONTAINS %@", "records.row.", name)).firstMatch
    }
    @MainActor private func createTodayPlan(_ name: String, in app: XCUIApplication) {
        app.tabBars.buttons["루틴함"].tap(); app.buttons["새 루틴"].tap()
        let field = app.textFields["routine.name"]
        XCTAssertTrue(field.waitForExistence(timeout: 5)); field.tap(); field.typeText(name); app.buttons["저장"].tap()
        app.tabBars.buttons["오늘"].tap()
        reveal(app.buttons["이번 주 보기"], in: app); app.buttons["이번 주 보기"].tap()
        reveal(app.buttons["week.plan"], in: app); app.buttons["week.plan"].tap()
        let toggle = app.switches[name], control = app.switches[name].switches.firstMatch
        reveal(control, in: app); control.tap(); XCTAssertEqual(toggle.value as? String, "1")
        reveal(app.buttons["회차 배치"], in: app); app.buttons["회차 배치"].tap(); app.buttons["계획에 담기"].tap()
        XCTAssertTrue(app.navigationBars["주간 계획"].waitForNonExistence(timeout: 5))
    }
    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication, upward: Bool = true) {
        for _ in 0..<15 {
            if element.exists && element.isHittable { return }
            if upward { app.collectionViews.firstMatch.swipeUp() } else { app.collectionViews.firstMatch.swipeDown() }
        }
    }
    @MainActor private func pickDate(_ date: Date, from source: Date, in app: XCUIApplication) {
        app.datePickers.firstMatch.tap()
        let calendar = Calendar(identifier: .gregorian)
        let target = calendar.dateComponents([.year, .month, .day], from: date)
        let start = calendar.dateComponents([.year, .month], from: source)
        let delta = ((target.year ?? 0) - (start.year ?? 0)) * 12 + (target.month ?? 0) - (start.month ?? 0)
        for _ in 0..<abs(delta) { app.buttons[delta < 0 ? "DatePicker.PreviousMonth" : "DatePicker.NextMonth"].tap() }
        let day = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "\(target.month ?? 1)월 \(target.day ?? 1)일 ")).firstMatch
        XCTAssertTrue(day.waitForExistence(timeout: 5)); day.tap()
        let outside = app.descendants(matching: .any).matching(identifier: "PopoverDismissRegion").firstMatch
        if outside.exists { outside.tap() }
    }
}
