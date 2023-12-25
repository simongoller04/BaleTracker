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

    var body: some View {
        Form {
            Section {
                Picker(R.string.localizable.crop(), selection: $selectedCrop) {
                    ForEach(Crop.allCases, id: \.self) { crop in
                        Text(crop.name)
                    }
                }
                .pickerStyle(.navigationLink)
            } header: {
                Text(R.string.localizable.selectCrop())
            }
            
            Section {
                Picker(R.string.localizable.baletype(), selection: $selectedBaleType) {
                    ForEach(BaleType.allCases, id: \.self) { baleType in
                        Text(baleType.name)
                    }
                }
                .pickerStyle(.navigationLink)
            } header: {
                Text(R.string.localizable.selectBaletype())
            }
        }
    }
}

#Preview("Dark") {
    BaleSettingsView(selectedCrop: .constant(.straw), selectedBaleType: .constant(.round))
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    BaleSettingsView(selectedCrop: .constant(.straw), selectedBaleType: .constant(.round))
        .preferredColorScheme(.light)
}
