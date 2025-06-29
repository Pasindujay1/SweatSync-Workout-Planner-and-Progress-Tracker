import XCTest

final class SweaySyncV2UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    @MainActor
    func testHomeScreenButtonsExist() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.buttons["Start Workout"].exists)
        XCTAssertTrue(app.buttons["View Progress"].exists)
        XCTAssertTrue(app.buttons["Saved Workouts"].exists)
    }

    @MainActor
    func testNavigateToSavedWorkouts() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Saved Workouts"].tap()

        XCTAssertTrue(app.staticTexts["Saved Workouts"].exists)
    }

    
}
