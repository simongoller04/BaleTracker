//
//  SelectFarmLocationView.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.11.23.
//

import SwiftUI
import MapKit

struct SelectFarmLocationView: View {
    @StateObject var viewModel: SelectFarmLocationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Namespace private var mapScope

    var body: some View {
        ZStack {
            Map(position: $viewModel.cameraPosition)
                .onMapCameraChange { context in
                    viewModel.position = .camera(context.camera)
                }
                .overlay {
                    Image(systemName: "mappin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(Color.red)
                        .padding(.bottom, 25) // bottom of the pin is the center of the screen
                }
                .ignoresSafeArea()
            
            ActionButton(text: "Select Farm Location") {
                dismiss()
            }
            .fullHeight(.bottom)
            .padding(.horizontal, Spacing.spacingM)
            
            VStack {
                MapUserLocationButton()
                MapCompass(scope: mapScope)
            }
            .fullHeight(.topTrailing)
            .padding(.trailing, Spacing.spacingS)
        }
//        .mapScope(mapScope)
    }
}

//struct SelectFarmLocationView_Preview: PreviewProvider {
//    static var previews: some View {
//        SelectFarmLocationView(viewModel: .init(location: .constant(CLLocationCoordinate2D.fixture())))
//            .lightPreview()
//        
//        SelectFarmLocationView(viewModel: .init(location: .constant(CLLocationCoordinate2D.fixture())))
//            .darkPreview()
//    }
//}
