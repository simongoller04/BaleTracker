//
//  ContentView.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.07.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    private var authenticationRepository = AuthenticationRepositoryImpl.shared

    var body: some View {
        switch authenticationRepository.loggedInfo {
        case .loggedOut:
            LoginView()
        case .loggedIn:
            main
        }
    }
    
    private var main: some View {
        TabView {
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text(R.string.localizable.map())
                }
            FarmView()
                .tabItem {
                    Image(systemName: "house")
                    Text(R.string.localizable.farms())
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
