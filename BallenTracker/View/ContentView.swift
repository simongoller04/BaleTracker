//
//  ContentView.swift
//  BallenTracker
//
//  Created by Simon Goller on 15.09.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                BalePreferences()
            }
            .tabItem {
                Label("Preferences", systemImage: "gear.circle.fill")
            }
           
            NavigationView {
                MapView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            
            NavigationView {
               ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}
