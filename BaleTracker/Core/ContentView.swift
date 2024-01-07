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
    @StateObject private var authenticationRepository = AuthenticationRepositoryImpl.shared

    var body: some View {
        switch authenticationRepository.loggedInfo {
        case .loggedOut:
            LoginView()
        case .loggedIn:
            main
        default:
            EmptyView()
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
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
