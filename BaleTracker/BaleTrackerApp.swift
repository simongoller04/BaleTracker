//
//  BaleTrackerApp.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.07.23.
//

import SwiftUI

@main
struct BaleTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
