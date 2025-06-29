//
//  PersistenceController.swift
//  SweaySyncV2
//
//  Created by Pasindu Jayasinghe on 6/15/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SweaySyncV2")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("❌ Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /// For preview or SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Example: create dummy workouts
        for i in 0..<5 {
            let workout = WorkoutEntity(context: viewContext)
            workout.name = "Preview Workout \(i)"
            workout.type = "Strength"
            workout.sets = 3
            workout.reps = 10
            workout.restTime = 30
            workout.date = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("❌ Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
}
