//
//  BallenTrackerApp.swift
//  BallenTracker
//
//  Created by Simon Goller on 27.07.22.
//

import SwiftUI

@main
struct BallenTrackerApp: App {
    // let persistenceController = PersistenceController.shared
    @StateObject var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            if viewModel.isLogedIn {
                ContentView()
                    .environmentObject(viewModel)
            }
            else {
                LoginView()
                    .environmentObject(viewModel)
            }

        }
    }
}
