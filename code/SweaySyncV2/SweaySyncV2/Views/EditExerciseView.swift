//
//  EditExerciseView.swift
//  SweaySyncV2
//
//  Created by Pasindu Jayasinghe on 6/24/25.
//

import SwiftUI

struct EditExerciseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var exercise: ExerciseEntity
    var onSave: () -> Void
    
    @State private var name: String
    @State private var sets: Int64
    @State private var reps: Int64
    
    init(exercise: ExerciseEntity, onSave: @escaping () -> Void) {
        self.exercise = exercise
        self.onSave = onSave
        _name = State(initialValue: exercise.name ?? "")
        _sets = State(initialValue: exercise.sets)
        _reps = State(initialValue: exercise.reps)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise Info")) {
                    TextField("Name", text: $name)
                    Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...20)
                }
            }
            .navigationTitle("Edit Exercise")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        exercise.name = name
                        exercise.sets = sets
                        exercise.reps = reps
                        do {
                            try viewContext.save()
                            onSave()
                            dismiss()
                        } catch {
                            print("❌ Failed to save exercise: \(error.localizedDescription)")
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
