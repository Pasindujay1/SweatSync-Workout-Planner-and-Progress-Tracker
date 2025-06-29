// WorkoutViewModel.swift
// SweaySyncV2

import Foundation
import CoreData
import PencilKit

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [WorkoutEntity] = []

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchWorkouts()
    }

    func fetchWorkouts() {
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]
        do {
            workouts = try context.fetch(request)
        } catch {
            print("❌ Error fetching workouts: \(error.localizedDescription)")
        }
    }

    func addWorkoutWithSketch(
        name: String,
        type: String,
        sets: Int64,
        reps: Int64,
        rest: Int64,
        date: Date,
        exercises: [ExerciseModel],
        sketch: PKDrawing
    ) {
        let workout = WorkoutEntity(context: context)
        workout.name = name
        workout.type = type
        workout.sets = sets
        workout.reps = reps
        workout.restTime = rest
        workout.date = date
        workout.sketchData = sketch.dataRepresentation()

        for model in exercises {
            let exercise = ExerciseEntity(context: context)
            exercise.name = model.name
            exercise.sets = Int64(model.sets)
            exercise.reps = Int64(model.reps)
            exercise.workout = workout
        }

        saveContext()
    }

    func deleteWorkout(_ workout: WorkoutEntity) {
        context.delete(workout)
        saveContext()
    }

    func updateWorkout(_ workout: WorkoutEntity, withName name: String, type: String, rest: Int64) {
        workout.name = name
        workout.type = type
        workout.restTime = rest
        saveContext()
    }

    private func saveContext() {
        //save context after bug fix
        do {
            try context.save()
            fetchWorkouts()
        } catch {
            print("❌ Error saving context: \(error.localizedDescription)")
        }
    }
}
