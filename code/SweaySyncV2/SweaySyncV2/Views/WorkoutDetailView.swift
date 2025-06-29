import SwiftUI
import PencilKit

struct WorkoutDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var editingExercise: ExerciseEntity?
    
    var workout: WorkoutEntity

    @FetchRequest private var exercises: FetchedResults<ExerciseEntity>
    
    init(workout: WorkoutEntity) {
        self.workout = workout
        _exercises = FetchRequest(
            entity: ExerciseEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseEntity.name, ascending: true)],
            predicate: NSPredicate(format: "workout == %@", workout)
        )
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.7), .purple.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .blur(radius: 0.5)
            
            ScrollView {
                VStack(spacing: 28) {
                    // Workout summary card
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue.opacity(0.25), .purple.opacity(0.25)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1.5)
                            )
                            .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                Image(systemName: iconName(for: workout.type ?? ""))
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(16)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, .purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(Circle())
                                    .shadow(radius: 6)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(workout.name ?? "Unnamed Workout")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                    Text(workout.type ?? "N/A")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                            }
                            
                            HStack(spacing: 20) {
                                detailIconRow(icon: "calendar", label: formattedDate(workout.date))
                                detailIconRow(icon: "timer", label: "\(workout.restTime) sec rest")
                                detailIconRow(icon: "repeat", label: "\(workout.sets)x\(workout.reps)")
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: workout.name)
                    
                    VStack(spacing: 8) {
                        Text("Exercises Progress")
                            .font(.headline)
                            .foregroundColor(.white)
                        ProgressView(value: Double(exercises.count), total: 10)
                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                            .scaleEffect(1.3)
                    }
                    
                    if let data = workout.sketchData, let drawing = try? PKDrawing(data: data) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Workout Sketch")
                                .font(.headline)
                                .foregroundColor(.white)
                            SketchView(drawing: .constant(drawing))
                                .frame(height: 220)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(radius: 4)
                        }
                        .padding(.horizontal)
                        .transition(.opacity)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Exercises")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        if exercises.isEmpty {
                            Text("No exercises added")
                                .foregroundColor(.white.opacity(0.7))
                                .italic()
                        } else {
                            ForEach(exercises, id: \.self) { ex in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(ex.name ?? "Unnamed Exercise")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("\(ex.sets)x\(ex.reps)")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    Spacer()
                                    Button {
                                        editingExercise = ex
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deleteExercise(ex)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 24)
            }
        }
        .sheet(item: $editingExercise) { exercise in
            EditExerciseView(exercise: exercise) {
            }
        }
    }
    
    private func detailIconRow(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
            Text(label)
                .foregroundColor(.white.opacity(0.9))
                .font(.subheadline)
        }
        .padding(6)
        .background(Color.white.opacity(0.08))
        .cornerRadius(8)
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func iconName(for type: String) -> String {
        switch type {
        case "Strength": return "dumbbell.fill"
        case "Cardio": return "heart.fill"
        case "Flexibility": return "figure.cooldown"
        case "HIIT": return "bolt.fill"
        default: return "questionmark.circle.fill"
        }
    }
    
    private func deleteExercise(_ exercise: ExerciseEntity) {
        viewContext.delete(exercise)
        do {
            try viewContext.save()
        } catch {
            print("❌ Failed to delete exercise: \(error.localizedDescription)")
        }
    }
}
