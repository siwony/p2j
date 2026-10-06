import XCTest

final class WeekPlanUITests: XCTestCase {
    @MainActor
    func testCreateCancelSkipRestoreAndRelaunch() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        let name = "Week \(UUID().uuidString.prefix(6))"
        createRoutine(name, in: app)
        app.tabBars.buttons["이번 주"].tap()
        reveal(app.buttons["week.plan"], in: app)
        app.buttons["week.plan"].tap()
        choose(name, in: app)
        app.buttons["취소"].tap()
        XCTAssertTrue(app.buttons["계속 편집"].waitForExistence(timeout: 5), app.debugDescription)
        app.buttons["계속 편집"].tap()
        reveal(app.buttons["회차 배치"], in: app)
        app.buttons["회차 배치"].tap()
        XCTAssertTrue(app.buttons["계획에 담기"].isEnabled)
        app.buttons["계획에 담기"].tap()
        XCTAssertTrue(app.navigationBars["이번 주"].waitForExistence(timeout: 5), app.debugDescription)
        let row = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(row, in: app, upward: false)
        XCTAssertTrue(row.waitForExistence(timeout: 5), app.debugDescription)
        row.buttons["건너뛰기"].tap()
        XCTAssertTrue(app.buttons["취소"].waitForExistence(timeout: 5))
        app.buttons["취소"].tap()
        XCTAssertTrue(row.buttons["옮기기"].exists)
        row.buttons["건너뛰기"].tap()
        let confirmation = app.sheets["이번 주에서는 건너뛸까요?"]
        XCTAssertTrue(confirmation.waitForExistence(timeout: 5), app.debugDescription)
        confirmation.buttons["건너뛰기"].tap()
        XCTAssertTrue(row.buttons["다시 계획하기"].waitForExistence(timeout: 5), app.debugDescription)
        row.buttons["다시 계획하기"].tap()
        app.buttons["저장"].tap()
        XCTAssertTrue(row.buttons["옮기기"].waitForExistence(timeout: 5))
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Week-agenda"; screenshot.lifetime = .keepAlways; add(screenshot)
        app.terminate(); app.launch()
        app.tabBars.buttons["이번 주"].tap()
        reveal(row, in: app)
        XCTAssertTrue(row.buttons["옮기기"].waitForExistence(timeout: 5), app.debugDescription)
    }

    @MainActor
    func testRestCancellationPreservesPlanAndRestoreUsesSameRow() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        let name = "Rest \(UUID().uuidString.prefix(6))"
        createRoutine(name, in: app)
        app.tabBars.buttons["이번 주"].tap()
        reveal(app.buttons["week.plan"], in: app)
        app.buttons["week.plan"].tap()
        choose(name, in: app)
        reveal(app.buttons["회차 배치"], in: app)
        app.buttons["회차 배치"].tap()
        app.buttons["계획에 담기"].tap()
        reveal(app.buttons["이번 주 남은 일정 쉬기"], in: app)
        app.buttons["이번 주 남은 일정 쉬기"].tap()
        XCTAssertTrue(app.staticTexts[name].exists)
        app.buttons["취소"].tap()
        reveal(app.buttons["이번 주 남은 일정 쉬기"], in: app)
        app.buttons["이번 주 남은 일정 쉬기"].tap()
        app.buttons["쉬기로 하기"].tap()
        XCTAssertTrue(app.staticTexts["이번 주 남은 일정은 쉬기로 했어요."].waitForExistence(timeout: 5), app.debugDescription)
        reveal(app.buttons["쉬기로 한 일정 보기"], in: app)
        app.buttons["쉬기로 한 일정 보기"].tap()
        let row = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(row, in: app, upward: false)
        XCTAssertTrue(row.buttons["다시 계획하기"].exists, app.debugDescription)
        row.buttons["다시 계획하기"].tap()
        app.buttons["저장"].tap()
        reveal(app.cells.containing(.staticText, identifier: name).firstMatch, in: app, upward: false)
        XCTAssertTrue(app.cells.containing(.staticText, identifier: name).firstMatch.buttons["옮기기"].exists)
    }

    @MainActor
    func testTodayRecoveryKeepsUnselectedAndReturnsToCallerOnCancel() throws {
        continueAfterFailure = false
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        let today = Date()
        let weekday = (calendar.component(.weekday, from: today) + 5) % 7 + 1
        guard weekday > 1 else { throw XCTSkip("월요일에는 이번 주 과거 날짜가 없습니다. 날짜·명령 단위 검증으로 경계를 확인합니다.") }
        let yesterday = try XCTUnwrap(calendar.date(byAdding: .day, value: -1, to: today))
        let app = XCUIApplication(); app.launch()
        let name = "Recover \(UUID().uuidString.prefix(6))"
        let other = name + " other"
        createRoutine(name, in: app); createRoutine(other, in: app)
        app.tabBars.buttons["이번 주"].tap()
        reveal(app.buttons["week.plan"], in: app); app.buttons["week.plan"].tap()
        choose(name, in: app); choose(other, in: app)
        reveal(app.buttons["회차 배치"], in: app); app.buttons["회차 배치"].tap()
        app.buttons["계획에 담기"].tap()
        for candidate in [name, other] {
            app.tabBars.buttons["오늘"].tap()
            reveal(app.buttons["이번 주 보기"], in: app); app.buttons["이번 주 보기"].tap()
            let row = app.cells.containing(.staticText, identifier: candidate).firstMatch
            reveal(row, in: app, upward: false)
            if !row.isHittable { reveal(row, in: app) }
            row.buttons["옮기기"].tap()
            pickDate(yesterday, from: today, in: app)
            app.buttons["저장"].tap()
        }
        app.tabBars.buttons["오늘"].tap()
        reveal(app.buttons["이번 주 계획 다시 고르기"], in: app)
        app.buttons["이번 주 계획 다시 고르기"].tap()
        XCTAssertTrue(app.navigationBars["이번 주 계획 다시 고르기"].waitForExistence(timeout: 5), app.debugDescription)
        XCTAssertFalse(app.buttons["저장"].isEnabled)
        let toggle = app.switches.matching(NSPredicate(format: "label BEGINSWITH %@", name + " · ")).firstMatch
        reveal(toggle, in: app)
        XCTAssertEqual(toggle.value as? String, "0")
        toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        app.buttons["취소"].tap(); app.buttons["변경 버리기"].tap()
        XCTAssertTrue(app.navigationBars["오늘"].waitForExistence(timeout: 5), app.debugDescription)
        app.buttons["이번 주 계획 다시 고르기"].tap()
        XCTAssertFalse(app.buttons["저장"].isEnabled)
        reveal(toggle, in: app)
        toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        app.buttons["저장"].tap()
        XCTAssertTrue(app.navigationBars["이번 주"].waitForExistence(timeout: 5))
        let recovered = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(recovered, in: app, upward: false)
        if !recovered.isHittable { reveal(recovered, in: app) }
        XCTAssertTrue(recovered.buttons["옮기기"].exists, app.debugDescription)
        XCTAssertFalse(app.cells.containing(.staticText, identifier: other).firstMatch.exists)
        reveal(app.buttons["week.day.\(weekday - 1)"], in: app, upward: false)
        app.buttons["week.day.\(weekday - 1)"].tap()
        let unselected = app.cells.containing(.staticText, identifier: other).firstMatch
        reveal(unselected, in: app)
        XCTAssertTrue(unselected.buttons["옮기기"].exists, app.debugDescription)
    }

    @MainActor
    func testPreviousPlanRequiresExplicitConfirmationAndExcludesArchivedRoutines() throws {
        continueAfterFailure = false
        let app = XCUIApplication(); app.launch()
        let name = "Import \(UUID().uuidString.prefix(6))"
        let archivedName = name + " archived"
        createRoutine(name, in: app); createRoutine(archivedName, in: app)
        app.tabBars.buttons["이번 주"].tap()
        reveal(app.buttons["지난주"], in: app, upward: false)
        app.buttons["지난주"].tap()
        reveal(app.buttons["week.plan"], in: app); app.buttons["week.plan"].tap()
        choose(name, in: app); choose(archivedName, in: app)
        reveal(app.buttons["회차 배치"], in: app); app.buttons["회차 배치"].tap()
        app.buttons["계획에 담기"].tap()
        app.tabBars.buttons["루틴함"].tap()
        let libraryRow = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@ AND label == %@", "routine.row.", archivedName)).firstMatch
        reveal(libraryRow, in: app)
        libraryRow.tap()
        reveal(app.buttons["보관"], in: app); app.buttons["보관"].tap()
        app.tabBars.buttons["오늘"].tap()
        XCTAssertFalse(app.staticTexts[name].exists)
        app.tabBars.buttons["이번 주"].tap()
        reveal(app.buttons["다음 주"], in: app, upward: false); app.buttons["다음 주"].tap()
        for shouldSave in [false, true] {
            reveal(app.buttons["week.plan"], in: app); app.buttons["week.plan"].tap()
            reveal(app.buttons["지난 계획 가져오기"], in: app)
            app.buttons["지난 계획 가져오기"].tap()
            let candidate = app.switches.matching(NSPredicate(format: "label BEGINSWITH %@", name + " · ")).firstMatch
            reveal(candidate, in: app)
            XCTAssertTrue(candidate.exists, app.debugDescription)
            XCTAssertEqual(candidate.value as? String, "0")
            XCTAssertFalse(app.switches.matching(NSPredicate(format: "label BEGINSWITH %@", archivedName + " · ")).firstMatch.exists)
            candidate.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
            reveal(app.buttons["회차 배치"], in: app); app.buttons["회차 배치"].tap()
            if shouldSave { app.buttons["계획에 담기"].tap() }
            else {
                app.buttons["취소"].tap(); app.buttons["변경 버리기"].tap()
                app.tabBars.buttons["오늘"].tap()
                XCTAssertFalse(app.staticTexts[name].exists)
                app.tabBars.buttons["이번 주"].tap()
            }
        }
        let row = app.cells.containing(.staticText, identifier: name).firstMatch
        reveal(row, in: app, upward: false)
        if !row.isHittable { reveal(row, in: app) }
        XCTAssertTrue(row.buttons["옮기기"].exists, app.debugDescription)
    }

    @MainActor
    private func pickDate(_ date: Date, from source: Date, in app: XCUIApplication) {
        app.datePickers.firstMatch.tap()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        let targetParts = calendar.dateComponents([.year, .month, .day], from: date)
        let sourceParts = calendar.dateComponents([.year, .month], from: source)
        let delta = ((targetParts.year ?? 0) - (sourceParts.year ?? 0)) * 12 + (targetParts.month ?? 0) - (sourceParts.month ?? 0)
        for _ in 0..<abs(delta) { app.buttons[delta < 0 ? "DatePicker.PreviousMonth" : "DatePicker.NextMonth"].tap() }
        let label = "\(targetParts.month ?? 1)월 \(targetParts.day ?? 1)일 "
        let day = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", label)).firstMatch
        XCTAssertTrue(day.waitForExistence(timeout: 5), app.debugDescription)
        day.tap()
        if app.buttons["PopoverDismissRegion"].exists { app.buttons["PopoverDismissRegion"].tap() }
    }

    @MainActor
    private func createRoutine(_ name: String, in app: XCUIApplication) {
        XCTAssertTrue(app.tabBars.buttons["루틴함"].waitForExistence(timeout: 10))
        app.tabBars.buttons["루틴함"].tap()
        app.buttons["새 루틴"].tap()
        let input = app.textFields["routine.name"]
        XCTAssertTrue(input.waitForExistence(timeout: 5))
        input.tap(); input.typeText(name)
        app.buttons["저장"].tap()
        XCTAssertTrue(app.navigationBars["루틴함"].waitForExistence(timeout: 5))
    }
    @MainActor
    private func choose(_ name: String, in app: XCUIApplication) {
        let toggle = app.switches[name]
        reveal(toggle, in: app)
        XCTAssertTrue(toggle.waitForExistence(timeout: 5), app.debugDescription)
        toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        XCTAssertEqual(toggle.value as? String, "1", app.debugDescription)
    }
    @MainActor
    private func reveal(_ element: XCUIElement, in app: XCUIApplication, upward: Bool = true) {
        for _ in 0..<12 {
            if element.exists && element.isHittable { return }
            if upward { app.collectionViews.firstMatch.swipeUp() }
            else { app.collectionViews.firstMatch.swipeDown() }
        }
    }
}
