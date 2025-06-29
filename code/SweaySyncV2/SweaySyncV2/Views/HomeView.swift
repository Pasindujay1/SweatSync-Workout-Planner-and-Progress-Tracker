import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = WorkoutViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Quote + Title
                    VStack(spacing: 8) {
                        Text("💬 \"Push yourself, because no one else is going to do it for you.\"")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Capsule())

                        Text("🏋️‍♂️ SweatSync")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)

                    NavigationLink(destination: WorkoutPlannerView(viewModel: viewModel)) {
                        HomeButton(title: "Start Workout", icon: "bolt.fill", color: .blue)
                    }

                    NavigationLink(destination: ProgressCalendarView(viewModel: viewModel)) {
                        HomeButton(title: "View Progress", icon: "chart.bar.fill", color: .green)
                    }

                    NavigationLink(destination: WorkoutListView()) {
                        HomeButton(title: "Saved Workouts", icon: "list.bullet.rectangle", color: .orange)
                    }

                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            }
        }
    }
}

struct HomeButton: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(color.opacity(0.85))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview {
    HomeView()
}
