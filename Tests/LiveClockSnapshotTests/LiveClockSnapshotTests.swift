import XCTest

final class LiveClockSnapshotTests: XCTestCase {
    private let nonexistencePredicate = NSPredicate(format: "exists == false")
    private let existencePredicate = NSPredicate(format: "exists == true")

    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    @MainActor
    func testTakeSnapshots() throws {
        XCUIDevice.shared.orientation = .portrait

        let app = XCUIApplication()

        expectation(
            for: existencePredicate,
            evaluatedWith: app.buttons["StartButton"],
            handler: nil)

        waitForExpectations(timeout: 10, handler: nil)

        snapshot("01_MainScreen_Stopped")

        app.buttons["StartButton"].tap()

        sleep(2)

        for _ in repeatElement((), count: 10) {
            app.buttons["LapButton"].tap()
            sleep(1)
        }

        snapshot("02_MainScreen_Started")

        app.navigationBars.firstMatch.buttons.firstMatch.tap()

        sleep(1)

        snapshot("03_LapList")

        app.navigationBars.firstMatch.buttons.firstMatch.tap()

        sleep(1)

        XCUIDevice.shared.orientation = .landscapeLeft

        sleep(1)

        snapshot("04_MainScreen_Landscape")
    }
}
