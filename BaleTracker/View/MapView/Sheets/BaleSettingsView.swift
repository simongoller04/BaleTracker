//
//  BaleSettingsView.swift
//  BaleTracker
//
//  Created by Simon Goller on 25.12.23.
//

import SwiftUI

struct BaleSettingsView: View {
    @Binding var selectedCrop: Crop
    @Binding var selectedBaleType: BaleType
    @Binding var selectedFarm: Farm?
    
    @StateObject private var viewModel = BaleSettingsViewModel()

    var body: some View {
        Form {
            Section {
                Picker(R.string.localizable.crop(), selection: $selectedCrop) {
                    ForEach(Crop.allCases, id: \.self) { crop in
                        Text(crop.name)
                    }
                }
            } header: {
                Text(R.string.localizable.selectCrop())
            }
            
            Section {
                Picker(R.string.localizable.baletype(), selection: $selectedBaleType) {
                    ForEach(BaleType.allCases, id: \.self) { baleType in
                        Text(baleType.name)
                    }
                }
            } header: {
                Text(R.string.localizable.selectBaletype())
            }
            
            if let farms = viewModel.farms {
                Section(R.string.localizable.selectFarm()) {
                    Picker(R.string.localizable.farm(), selection: $selectedFarm) {
                        Text(R.string.localizable.noFarmSelected()).tag(nil as Farm?)
                        ForEach(farms, id: \.id) { farm in
                            Text(farm.name).tag(farm as Farm?)
                        }
                    }
                }
            }
        }
    }
}

#Preview("Dark") {
    BaleSettingsView(selectedCrop: .constant(.straw), selectedBaleType: .constant(.round), selectedFarm: .constant(.fixture()))
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    BaleSettingsView(selectedCrop: .constant(.straw), selectedBaleType: .constant(.round), selectedFarm: .constant(.fixture()))  
        .preferredColorScheme(.light)
}
