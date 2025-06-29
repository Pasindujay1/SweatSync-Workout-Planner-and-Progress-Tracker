import SwiftUI

struct WorkoutListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = WorkoutViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)],
        animation: .default
    )
    private var workouts: FetchedResults<WorkoutEntity>
    
    @State private var selectedWorkout: WorkoutEntity? = nil
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Enhanced Header
                HStack {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.trailing, 8)
                    Text("Saved Workouts")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .blur(radius: 0.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                .padding(.top, 8)

                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(workouts) { workout in
                            Button(action: {
                                selectedWorkout = workout
                            }) {
                                WorkoutCard(workout: workout)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: workouts.count)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.deleteWorkout(workout)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        if workouts.isEmpty {
                            Text("No saved workouts yet.")
                                .foregroundColor(.white.opacity(0.7))
                                .italic()
                                .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
            }
            // Floating action button (optional, for future add)
            /*
            Button(action: {
                // Action for adding a new workout
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .clipShape(Circle())
                    .shadow(radius: 6)
            }
            .padding()
            */
        }
        .sheet(item: $selectedWorkout) { workout in
            WorkoutDetailView(workout: workout)
        }
    }
}

struct WorkoutCard: View {
    let workout: WorkoutEntity

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.25), .purple.opacity(0.25)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 54, height: 54)
                        .shadow(radius: 4)
                    Image(systemName: iconName(for: workout.type ?? ""))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(workout.name ?? "Unnamed Workout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text("\(workout.type ?? "") • \(formattedDate(workout.date))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding(.horizontal, 2)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func iconName(for type: String) -> String {
        switch type {
        case "Strength":
            return "dumbbell.fill"
        case "Cardio":
            return "heart.fill"
        case "Flexibility":
            return "figure.cooldown"
        case "HIIT":
            return "bolt.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
}
