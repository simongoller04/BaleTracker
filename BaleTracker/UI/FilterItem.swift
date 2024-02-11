//
//  FilterItem.swift
//  BaleTracker
//
//  Created by Simon Goller on 03.02.24.
//

import SwiftUI

struct FilterItem<F: Filter>: View {
    @Binding var selection: F
    var selectables: [F]
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(selectables, id: \.self) { selectable in
                Label(selectable.name, systemImage: selectable.systemImage)
            }
        }
        .padding(Spacing.spacingXS)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview("Light") {
    FilterItem(selection: .constant(CropFilter.grass), selectables: CropFilter.allCases)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    FilterItem(selection: .constant(CropFilter.grass), selectables: CropFilter.allCases)
        .preferredColorScheme(.dark)
}
