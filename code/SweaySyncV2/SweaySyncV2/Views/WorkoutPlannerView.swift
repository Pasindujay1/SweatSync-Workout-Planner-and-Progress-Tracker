
import SwiftUI
import PencilKit

struct WorkoutPlannerView: View {
    @ObservedObject var viewModel: WorkoutViewModel

    @State private var name = ""
    @State private var type = "Strength"
    @State private var sets: Int64 = 3
    @State private var reps: Int64 = 10
    @State private var restTime: Int64 = 30
    @State private var date = Date()
    @State private var exerciseName = ""
    @State private var exerciseSets: Int64 = 3
    @State private var exerciseReps: Int64 = 10
    @State private var tempExercises: [ExerciseModel] = []
    @State private var sketch = PKDrawing()

    let types = ["Strength", "Cardio", "Flexibility", "HIIT"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("🏋️‍♂️ Create Workout")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 20)

                workoutDetailsCard
                addExerciseCard
                exercisesList
                sketchSection
                saveButton
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    var workoutDetailsCard: some View {
        VStack(spacing: 12) {
            TextField("Workout Name", text: $name)
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)
                .foregroundColor(.white)

            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)

            HStack {
                Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                Spacer()
                Stepper("Reps: \(reps)", value: $reps, in: 1...20)
            }
            .foregroundColor(.white)

            Stepper("Rest: \(restTime) sec", value: $restTime, in: 10...120, step: 10)
                .foregroundColor(.white)

            DatePicker("Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
    }

    var addExerciseCard: some View {
        VStack(spacing: 12) {
            TextField("Exercise Name", text: $exerciseName)
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)
                .foregroundColor(.white)

            HStack {
                Stepper("Sets: \(exerciseSets)", value: $exerciseSets, in: 1...10)
                Spacer()
                Stepper("Reps: \(exerciseReps)", value: $exerciseReps, in: 1...20)
            }
            .foregroundColor(.white)

            Button {
                withAnimation {
                    let newEx = ExerciseModel(name: exerciseName, sets: Int(exerciseSets), reps: Int(exerciseReps))
                    tempExercises.append(newEx)
                    exerciseName = ""
                    exerciseSets = 3
                    exerciseReps = 10
                }
            } label: {
                Label("Add Exercise", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(exerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
    }

    var exercisesList: some View {
        VStack(alignment: .leading, spacing: 8) {
            if tempExercises.isEmpty {
                Text("No exercises added yet")
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
            } else {
                Text("📋 Exercises Added")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                ForEach(tempExercises) { ex in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(ex.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(ex.sets)x\(ex.reps)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                if let index = tempExercises.firstIndex(where: { $0.id == ex.id }) {
                                    tempExercises.remove(at: index)
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(8)
                }
            }
        }
    }

    var sketchSection: some View {
        VStack(spacing: 8) {
            Text("📝 Sketch")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            SketchView(drawing: $sketch)
                .frame(height: 300)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
        }
    }

    var saveButton: some View {
        Button {
            viewModel.addWorkoutWithSketch(
                name: name,
                type: type,
                sets: sets,
                reps: reps,
                rest: restTime,
                date: date,
                exercises: tempExercises,
                sketch: sketch
            )

            HealthKitManager.shared.saveWorkout(
                start: date,
                duration: 60 * 5,
                calories: 200
            )

            resetForm()
        } label: {
            Text("✅ Save Workout")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
    }

    private func resetForm() {
        name = ""
        type = "Strength"
        sets = 3
        reps = 10
        restTime = 30
        date = Date()
        tempExercises.removeAll()
        sketch = PKDrawing()
    }
}
