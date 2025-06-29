
import SwiftUI

struct ProgressCalendarView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var selectedDate = Date()

    var filteredWorkouts: [WorkoutEntity] {
        let calendar = Calendar.current
        return viewModel.workouts.filter { workout in
            if let date = workout.date {
                return calendar.isDate(date, inSameDayAs: selectedDate)
            }
            return false
        }
    }

    let columns = [GridItem(.adaptive(minimum: 250), spacing: 16)]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.title2)
                    Text("Progress Calendar")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)

                if filteredWorkouts.isEmpty {
                    Text("No workouts for \(formattedDate(selectedDate))")
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredWorkouts, id: \.objectID) { workout in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "dumbbell.fill")
                                            .foregroundColor(.white)
                                        Text(workout.name ?? "Unnamed Workout")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    Text("\(workout.type ?? "") • \(workout.sets)x\(workout.reps)")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                    Text("🕒 Rest: \(workout.restTime) sec")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .animation(.easeInOut(duration: 0.3), value: filteredWorkouts.count)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
