//
//  FarmView.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import SwiftUI

struct FarmView: View {
    @StateObject private var viewModel = FarmViewModel()
    
    @State private var showAddFarm = false
    @State private var showProfile = false
    
    var body: some View {
        NavigationStack {
            list()
                .searchable(text: $viewModel.searchableText, placement: .navigationBarDrawer(displayMode: .always), prompt: R.string.localizable.searchablePlaceholderFarm())
                .navigationTitle(R.string.localizable.farms())
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        Button {
                            showAddFarm = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showProfile = true
                        } label: {
                            Image(systemName: "person.circle")
                            // TODO: replace with profile picture of user
                        }

                    }
                }
                .refreshable {
                    viewModel.fetchFarms()
                }
                .sheet(isPresented: $showAddFarm) {
                    addFarm()
                }
                .sheet(isPresented: $showProfile) {
                    profile()
                }
        }
    }
    
    @ViewBuilder
    private func list() -> some View {
        if let farms = viewModel.filteredFarms {
            List {
                ForEach(farms, id: \.id) { farm in
                    listItem(farm: farm)
                }
            }
        }
    }
    
    private func listItem(farm: Farm) -> some View {
        HStack(spacing: 16) {
            Image(systemName: "person.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 32)
            
            VStack(alignment: .leading) {
                Text(farm.name)
                    .bold()
                if farm.members.count > 1 {
                    Text("\(farm.members.count) \(R.string.localizable.members())")
                } else {
                    Text("\(farm.members.count) \(R.string.localizable.member())")
                }
            }
        }
    }
    
    private func addFarm() -> some View {
        VStack {
            // TODO: implement add farm screen
            Text("todo")
        }
    }
    
    private func profile() -> some View {
        VStack {
            // TODO: implement add profile screen
            Text("todo")
        }
    }
}

struct FarmView_Previews: PreviewProvider {
    static var previews: some View {
        FarmView()
            .darkPreview()
        
        FarmView()
            .lightPreview()
    }
}
