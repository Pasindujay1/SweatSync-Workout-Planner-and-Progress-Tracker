import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    func requestAuthorization() {
        let typesToShare: Set = [
            HKObjectType.workoutType()
        ]
        let typesToRead: Set = [
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error = error {
                print("❌ HealthKit authorization error: \(error.localizedDescription)")
            } else {
                print(success ? "✅ HealthKit authorization granted" : "⚠️ HealthKit authorization denied")
            }
        }
    }

    func saveWorkout(start: Date, duration: TimeInterval, calories: Double) {
        let end = start.addingTimeInterval(duration)
        
        let metadata = [
            HKMetadataKeyIndoorWorkout: true,
            HKMetadataKeyWorkoutBrandName: "SweaySyncV2"
        ] as [String : Any]

        let workout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: start,
            end: end,
            duration: duration,
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: calories),
            totalDistance: nil,
            metadata: metadata
        )

        healthStore.save(workout) { success, error in
            if let error = error {
                print("❌ Failed to save workout: \(error.localizedDescription)")
            } else {
                print("✅ Workout saved to Health app")
            }
        }
    }
}
