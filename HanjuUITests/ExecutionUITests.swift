import XCTest

final class ExecutionUITests: XCTestCase {
    @MainActor
    func testRunningSurvivesNavigationRelaunchAndSwitchCancellation() throws {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        let first = "Timer \(UUID().uuidString.prefix(6))", second = "Switch \(UUID().uuidString.prefix(6))"
        try createTodayPlans([first, second], in: app)
        app.tabBars.buttons["오늘"].tap()
        let firstRow = app.cells.containing(.staticText, identifier: first).firstMatch
        reveal(firstRow, in: app)
        firstRow.buttons["시작"].tap()
        if app.buttons["일시정지하고 시작"].exists { app.buttons["일시정지하고 시작"].tap() }
        XCTAssertTrue(app.navigationBars["실행 중"].waitForExistence(timeout: 5), app.debugDescription)
        XCTAssertTrue(app.staticTexts["execution.timer"].exists)
        app.buttons["오늘로 돌아가기"].tap()
        XCTAssertTrue(app.otherElements["execution.active"].exists || app.staticTexts[first].exists)
        app.tabBars.buttons["이번 주"].tap(); app.tabBars.buttons["오늘"].tap()
        let secondRow = app.cells.containing(.staticText, identifier: second).firstMatch
        reveal(secondRow, in: app); secondRow.buttons["시작"].tap()
        let switchDialog = app.sheets["하던 일을 일시정지하고 시작할까요?"]
        XCTAssertTrue(switchDialog.waitForExistence(timeout: 5), app.debugDescription)
        cancel(switchDialog, in: app)
        XCTAssertTrue(app.navigationBars["오늘"].exists)
        reveal(secondRow, in: app); secondRow.buttons["시작"].tap()
        app.buttons["일시정지하고 시작"].tap()
        XCTAssertTrue(app.navigationBars["실행 중"].waitForExistence(timeout: 5))
        app.terminate(); app.launch()
        let active = app.cells.containing(.button, identifier: "실행 상세").firstMatch
        XCTAssertTrue(active.waitForExistence(timeout: 10), app.debugDescription)
        XCTAssertTrue(active.staticTexts[second].exists)
        active.buttons["실행 상세"].tap()
        app.buttons["일시정지"].tap()
        XCTAssertTrue(app.buttons["이어서 하기"].waitForExistence(timeout: 5))
        app.buttons["이어서 하기"].tap()
        let image = XCTAttachment(screenshot: app.screenshot()); image.name = "Running-routine"; image.lifetime = .keepAlways; add(image)
        app.buttons["완료"].tap()
        XCTAssertTrue(app.navigationBars["오늘"].waitForExistence(timeout: 5))
        reveal(app.cells.containing(.staticText, identifier: second).firstMatch, in: app)
        XCTAssertTrue(app.cells.containing(.staticText, identifier: second).firstMatch.buttons.firstMatch.exists)
    }

    @MainActor
    func testDirectCompletionEditCancellationZeroTimeAndUndo() throws {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        let name = "Direct \(UUID().uuidString.prefix(6))"
        try createTodayPlans([name], in: app)
        app.tabBars.buttons["오늘"].tap()
        let row = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(row, in: app); row.buttons["이미 했어요"].tap()
        reveal(row, in: app); row.buttons.firstMatch.tap()
        XCTAssertTrue(app.navigationBars["실행 기록"].waitForExistence(timeout: 5), app.debugDescription)
        XCTAssertTrue(app.staticTexts["시간 미기록"].exists)
        let field = app.textFields["execution.minutes"]
        field.tap(); field.typeText("15")
        app.buttons["취소"].tap()
        XCTAssertTrue(app.buttons["계속 편집"].waitForExistence(timeout: 5))
        app.buttons["계속 편집"].tap()
        XCTAssertEqual(field.value as? String, "15")
        app.buttons["취소"].tap(); app.buttons["변경 버리기"].tap()
        reveal(row, in: app); row.buttons.firstMatch.tap()
        XCTAssertEqual(field.value as? String, "선택 사항")
        field.tap(); field.typeText("0")
        app.buttons["저장"].tap()
        reveal(row, in: app)
        XCTAssertTrue(row.staticTexts["0분 기록"].exists, app.debugDescription)
        row.buttons.firstMatch.tap()
        reveal(app.buttons["완료 취소"], in: app); app.buttons["완료 취소"].tap()
        app.sheets["완료 표시를 취소할까요?"].buttons["완료 취소"].tap()
        reveal(row, in: app)
        XCTAssertTrue(row.buttons["이미 했어요"].exists, app.debugDescription)
        XCTAssertFalse(app.staticTexts["완료했어요."].exists)
        row.buttons["이미 했어요"].tap()
        reveal(row, in: app); XCTAssertTrue(row.staticTexts["0분 기록"].exists)
        let image = XCTAttachment(screenshot: app.screenshot()); image.name = "Direct-completion"; image.lifetime = .keepAlways; add(image)
    }

    @MainActor
    func testRunningRestStopsAndRestoreRetainsMeasuredHistory() throws {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        let name = "RestTimer \(UUID().uuidString.prefix(6))"
        try createTodayPlans([name], in: app)
        app.tabBars.buttons["오늘"].tap()
        let row = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(row, in: app); row.buttons["시작"].tap()
        if app.buttons["일시정지하고 시작"].exists { app.buttons["일시정지하고 시작"].tap() }
        XCTAssertTrue(app.navigationBars["실행 중"].waitForExistence(timeout: 5))
        app.tabBars.buttons["이번 주"].tap()
        reveal(app.buttons["이번 주 남은 일정 쉬기"], in: app); app.buttons["이번 주 남은 일정 쉬기"].tap()
        XCTAssertTrue(app.staticTexts[name].exists)
        app.buttons["취소"].tap()
        app.tabBars.buttons["오늘"].tap()
        XCTAssertTrue(app.buttons["일시정지"].exists)
        app.tabBars.buttons["이번 주"].tap()
        reveal(app.buttons["이번 주 남은 일정 쉬기"], in: app); app.buttons["이번 주 남은 일정 쉬기"].tap()
        app.buttons["쉬기로 하기"].tap()
        reveal(row, in: app, upward: false); if !row.isHittable { reveal(row, in: app) }
        row.buttons["다시 계획하기"].tap(); app.buttons["저장"].tap()
        reveal(row, in: app, upward: false); if !row.isHittable { reveal(row, in: app) }
        XCTAssertTrue(row.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "일시정지")).firstMatch.exists, app.debugDescription)
        row.buttons["이미 했어요"].tap(); row.buttons["기록 편집"].tap()
        XCTAssertFalse(app.staticTexts["시간 미기록"].exists)
        XCTAssertTrue(app.staticTexts["execution.duration"].exists)
    }

    @MainActor
    func testPriorWeekDirectCompletionAndPerformedDateCorrectionKeepPlanInPlace() throws {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        let name = "Late \(UUID().uuidString.prefix(6))"
        try createTodayPlans([name], in: app)
        let row = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(row, in: app, upward: false); if !row.buttons.firstMatch.isHittable { reveal(row, in: app) }
        row.buttons["옮기기"].tap()
        let today = Date(), calendar = Calendar(identifier: .gregorian)
        let lastWeek = try XCTUnwrap(calendar.date(byAdding: .day, value: -7, to: today))
        pickDate(lastWeek, from: today, in: app)
        app.buttons["저장"].tap()
        reveal(row, in: app, upward: false); if !row.buttons.firstMatch.isHittable { reveal(row, in: app) }
        row.buttons["이미 했어요"].tap()
        XCTAssertTrue(row.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "시간 미기록")).firstMatch.exists)
        row.buttons["기록 편집"].tap()
        XCTAssertTrue(app.navigationBars["실행 기록"].waitForExistence(timeout: 5))
        pickDate(lastWeek, from: today, in: app)
        let capture = XCTAttachment(screenshot: app.screenshot()); capture.name = "Performed-date-edit"; capture.lifetime = .keepAlways; add(capture)
        app.buttons["저장"].tap()
        reveal(row, in: app, upward: false); if !row.buttons.firstMatch.isHittable { reveal(row, in: app) }
        XCTAssertTrue(row.buttons["기록 편집"].exists, app.debugDescription)
        XCTAssertTrue(row.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "시간 미기록")).firstMatch.exists)
        row.buttons["기록 편집"].tap()
        let dateValue = app.datePickers.firstMatch.value as? String ?? ""
        XCTAssertTrue(dateValue.contains("\(calendar.component(.day, from: lastWeek))"), app.debugDescription)
        app.buttons["취소"].tap()
        app.tabBars.buttons["오늘"].tap()
        XCTAssertFalse(app.cells.containing(.staticText, identifier: name).firstMatch.exists)
    }

    @MainActor private func pickDate(_ date: Date, from source: Date, in app: XCUIApplication) {
        app.datePickers.firstMatch.tap()
        let calendar = Calendar(identifier: .gregorian)
        let target = calendar.dateComponents([.year, .month, .day], from: date)
        let initial = calendar.dateComponents([.year, .month], from: source)
        let delta = ((target.year ?? 0) - (initial.year ?? 0)) * 12 + (target.month ?? 0) - (initial.month ?? 0)
        for _ in 0..<abs(delta) { app.buttons[delta < 0 ? "DatePicker.PreviousMonth" : "DatePicker.NextMonth"].tap() }
        let day = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "\(target.month ?? 1)월 \(target.day ?? 1)일 ")).firstMatch
        XCTAssertTrue(day.waitForExistence(timeout: 5), app.debugDescription); day.tap()
        let outside = app.descendants(matching: .any).matching(identifier: "PopoverDismissRegion").firstMatch
        if outside.exists { outside.tap() }
    }

    @MainActor private func createTodayPlans(_ names: [String], in app: XCUIApplication) throws {
        for name in names {
            XCTAssertTrue(app.tabBars.buttons["루틴함"].waitForExistence(timeout: 10))
            app.tabBars.buttons["루틴함"].tap(); app.buttons["새 루틴"].tap()
            let field = app.textFields["routine.name"]; XCTAssertTrue(field.waitForExistence(timeout: 5))
            field.tap(); field.typeText(name); app.buttons["저장"].tap()
        }
        app.tabBars.buttons["오늘"].tap()
        reveal(app.buttons["이번 주 보기"], in: app); app.buttons["이번 주 보기"].tap()
        reveal(app.buttons["week.plan"], in: app); app.buttons["week.plan"].tap()
        for name in names {
            let toggle = app.switches[name]; reveal(toggle, in: app)
            toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        }
        reveal(app.buttons["회차 배치"], in: app); app.buttons["회차 배치"].tap(); app.buttons["계획에 담기"].tap()
        XCTAssertTrue(app.navigationBars["이번 주"].waitForExistence(timeout: 5))
    }
    @MainActor private func cancel(_ dialog: XCUIElement, in app: XCUIApplication) {
        if dialog.buttons["취소"].exists { dialog.buttons["취소"].tap() }
        else {
            let outside = app.descendants(matching: .any).matching(identifier: "PopoverDismissRegion").firstMatch
            XCTAssertTrue(outside.exists, app.debugDescription); outside.tap()
        }
        XCTAssertTrue(dialog.waitForNonExistence(timeout: 5))
    }
    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication, upward: Bool = true) {
        for _ in 0..<15 {
            if element.exists {
                let target = element.elementType == .cell ? element.buttons.firstMatch : element
                if target.exists && target.isHittable { return }
            }
            if upward { app.collectionViews.firstMatch.swipeUp() } else { app.collectionViews.firstMatch.swipeDown() }
        }
    }
}
