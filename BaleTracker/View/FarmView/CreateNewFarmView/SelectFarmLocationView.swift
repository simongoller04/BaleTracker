//
//  SelectFarmLocationView.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.11.23.
//

import SwiftUI
import MapKit

struct SelectFarmLocationView: View {
    @EnvironmentObject var viewModel: CreateNewFarmViewModel
    @Environment(\.dismiss) private var dismiss
        
    private var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    
    var body: some View {
        ZStack {
            Map(initialPosition: .automatic)
                .onMapCameraChange { context in
                    var region = context.region
                    region.span = span
                    viewModel.region = region
                }
                .overlay {
                    Image(systemName: "mappin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(Color.red)
                        .padding(.bottom, 25) // bottom of the pin is the center of the screen
                }
            
            Button {
                dismiss()
                viewModel.region = nil
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.primary)
            .font(.system(size: 30))
            .fullHeight(.top)
            .fullWidth(.leading)
            .padding(Spacing.spacingM)
            
            ActionButton(text: "Select Farm Location") {
                dismiss()
            }
            .fullHeight(.bottom)
            .padding(.horizontal, Spacing.spacingM)
        }
    }
}

#Preview("Dark") {
    SelectFarmLocationView()
        .environmentObject(CreateNewFarmViewModel())
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    SelectFarmLocationView()
        .environmentObject(CreateNewFarmViewModel())
        .preferredColorScheme(.light)
}

