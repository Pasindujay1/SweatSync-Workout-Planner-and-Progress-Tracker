//
//  SweaySyncV2App.swift
//  SweaySyncV2
//
//  Created by Pasindu Jayasinghe on 6/14/25.
//

import SwiftUI

@main
struct SweaySyncV2App: App {
    let persistenceController = PersistenceController.shared

    init() {
        HealthKitManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
