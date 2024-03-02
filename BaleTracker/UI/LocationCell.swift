//
//  LocationCell.swift
//  BaleTracker
//
//  Created by Simon Goller on 02.03.24.
//

import SwiftUI
import MapKit

struct LocationCell<Content: View>: View {
    var region: MKCoordinateRegion
    var button: () -> Content?
    
    private var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    
    init(region: MKCoordinateRegion, @ViewBuilder button: @escaping () -> Content? = { EmptyView() }) {
        self.region = region
        self.region.span = span
        self.button = button
    }
    
    var body: some View {
        VStack(spacing: 0) {
            map
            coordinates
                .padding(Spacing.spacingM)
        }
    }
    
    private var map: some View {
        Map(position: .constant(.region(region))) {
            Annotation("Home", coordinate: region.center) {
                Image(systemName: "house.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.cyan)
            }
        }
        .allowsHitTesting(false)
        .frame(width: .infinity, height: 200)
    }
    
    private var coordinates: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Coordinates".uppercased())
                    .font(.footnote)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                Text(region.center.toString())
                    .foregroundStyle(Color(uiColor: .label))
            }
            .fullWidth(.leading)
            
            button()
        }
    }
}

#Preview("Dark") {
    VStack {
        LocationCell(region: .init()) {
            Button("Test") {
                print("pressed")
            }
        }
        
        LocationCell(region: .init())
    }
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    VStack {
        LocationCell(region: .init()) {
            Button("Test") {
                print("pressed")
            }
        }
        
        LocationCell(region: .init())
    }
    .preferredColorScheme(.light)
}
