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
                }
                .sheet(isPresented: $showAddFarm) {
                    CreateNewFarmView()
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
            Image(systemName: "person.2.circle")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.primary)
                .font(.system(size: 36))
            
            VStack(alignment: .leading) {
                Text(farm.name)
                    .bold()
                if farm.members.count > 1 {
                    Text("\(farm.members.count) \(R.string.localizable.members())")
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(farm.members.count) \(R.string.localizable.member())")
                        .foregroundStyle(.secondary)

                }
            }
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
