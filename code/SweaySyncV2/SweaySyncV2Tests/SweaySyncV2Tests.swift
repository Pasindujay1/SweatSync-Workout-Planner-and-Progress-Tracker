import XCTest
import PencilKit
import CoreData
@testable import SweaySyncV2

final class SweaySyncV2Tests: XCTestCase {
    var viewModel: WorkoutViewModel!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: "SweaySyncV2")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
        viewModel = WorkoutViewModel(context: context)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
    }

    func testAddWorkout() throws {
        let initialCount = viewModel.workouts.count
        viewModel.addWorkoutWithSketch(
            name: "Test Workout",
            type: "Strength",
            sets: 3,
            reps: 10,
            rest: 30,
            date: Date(),
            exercises: [],
            sketch: PKDrawing()
        )
        viewModel.fetchWorkouts()
        XCTAssertEqual(viewModel.workouts.count, initialCount + 1)
        XCTAssertEqual(viewModel.workouts.first?.name, "Test Workout")
    }

    func testDeleteWorkout() throws {
        viewModel.addWorkoutWithSketch(
            name: "Delete Me",
            type: "Cardio",
            sets: 2,
            reps: 5,
            rest: 20,
            date: Date(),
            exercises: [],
            sketch: PKDrawing()
        )
        viewModel.fetchWorkouts()
        let workout = viewModel.workouts.first!
        viewModel.deleteWorkout(workout)
        viewModel.fetchWorkouts()
        XCTAssertFalse(viewModel.workouts.contains(where: { $0.name == "Delete Me" }))
    }
}
