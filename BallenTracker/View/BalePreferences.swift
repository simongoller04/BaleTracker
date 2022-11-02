//
//  BalePreferences.swift
//  BallenTracker
//
//  Created by Simon Goller on 27.07.22.
//

import SwiftUI

struct BalePreferences: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    let baleTypesArray: [BaleType] = [.square, .round, .wrappedRound, .wrappedSquare]
    let cropTypesArray: [CropType] = [.straw, .cornSilage, .grass, .grassSilge, .hay]
    
    @State private var baleTypeIsExpanded = false
    @State private var cropTypeIsExpanded = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Bale Type")) {
                    DisclosureGroup(handleBaleType(baleType: viewModel.currentBaleType), isExpanded: $baleTypeIsExpanded) {
                        ForEach(baleTypesArray, id: \.self) { baleType in
                            Text(handleBaleType(baleType: baleType))
                                .onTapGesture {
                                    viewModel.currentBaleType = baleType
                                    withAnimation {
                                        baleTypeIsExpanded = false
                                    }
                                }
                        }
                    }
                }
                
                Section(header: Text("Crop Type")) {
                    DisclosureGroup(handleCropType(cropType: viewModel.currentCropType), isExpanded: $cropTypeIsExpanded) {
                        ForEach(cropTypesArray, id: \.self) { cropType in
                            Text(handleCropType(cropType: cropType))
                                .onTapGesture {
                                    viewModel.currentCropType = cropType
                                    cropTypeIsExpanded = false
                                }
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Bale Preferences")
    }
}
