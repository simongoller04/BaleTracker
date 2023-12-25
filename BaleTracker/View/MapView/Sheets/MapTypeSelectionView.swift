//
//  MapTypeSelectionView.swift
//  BaleTracker
//
//  Created by Simon Goller on 21.12.23.
//

import SwiftUI
import _MapKit_SwiftUI

struct MapTypeSelectionView: View {
    @Binding var mapStyle: MapStyle
    
    var body: some View {
        HStack(spacing: Spacing.spacingM) {
            card(image: "globe.europe.africa.fill", text: R.string.localizable.sattelite(), color: .blue, style: .imagery)
            card(image: "map.fill", text: R.string.localizable.standard(), color: .indigo, style: .standard)
            card(image: "car", text: R.string.localizable.driving(), color: .purple, style: .hybrid(showsTraffic: true))
        }
    }
    
    private func card(image: String, text: String, color: Color, style: MapStyle) -> some View {
        Button {
            mapStyle = style
        } label: {
            VStack(spacing: 0) {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding(Spacing.spacingS)
                
                Text(text)
                    .font(.caption)
                    .fullWidth(.leading)
                    .padding(Spacing.spacingS)
                    .background(.thinMaterial)
            }
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(10)
        }
        .foregroundStyle(.foreground)
    }
}

#Preview("Dark") {
    MapTypeSelectionView(mapStyle: .constant(.hybrid))
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    MapTypeSelectionView(mapStyle: .constant(.hybrid))        
        .preferredColorScheme(.light)
}
