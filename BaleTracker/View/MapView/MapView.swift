//
//  MapView.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import SwiftUI
import MapKit

enum MapViewSheet: Identifiable {
    case mapTypeSelector
    case baleSettings
    case balesNearYou
    
    var id: Int {
        hashValue
    }
}

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @StateObject private var locationPermission = LocationPermission()
    
    @State private var activeSheet: MapViewSheet?
    
    @State private var sheetHeight: CGFloat = .infinity
    @State private var sheetHeightSecond: CGFloat = .infinity

    @Namespace var mapScope
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(scope: mapScope) {
                Annotation("test", coordinate: .fixture()) {
                    BaleAnnotation(bale: .fixture())
                }
                Annotation("test", coordinate: .fixture()) {
                    BaleAnnotation(bale: .fixture(collected: true))
                }
            }
            .mapStyle(viewModel.mapStyle)
            .ignoresSafeArea()
            
            buttonList
            
            HStack {
                ActionButton(text: R.string.localizable.addBale(), image: Image(systemName: "plus")) {
                    //
                }
                
                ActionButton(image: Image(systemName: "gear"),
                             buttonWidth: CGFloat(50)) {
                    activeSheet = .baleSettings
                }
            }
            .fullHeight(.bottom)
            .padding(.horizontal, Spacing.spacingM)
            .padding(.bottom, Spacing.spacingM)
        }
        .mapScope(mapScope)
        .onAppear {
            locationPermission.requestLocationPermission()
        }
        .sheet(item: $activeSheet) { sheet in
            sheetBuilder(sheet: sheet)
        }
    }
    
    private var buttonList: some View {
        VStack {
            VStack(spacing: 0) {
                MapUserLocationButton(scope: mapScope)
                Divider()
                Button {
                    activeSheet = .mapTypeSelector
                } label: {
                    Image(systemName: "map")
                        .frame(width: Spacing.spacing2XL, height: Spacing.spacing2XL)
                }
                Divider()
                Button {
                    activeSheet = .balesNearYou
                } label: {
                    Image(systemName: "circle.circle")
                        .frame(width: Spacing.spacing2XL, height: Spacing.spacing2XL)
                }
            }
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(10)
            .frame(width: Spacing.spacing2XL)
            .padding(Spacing.spacingM)
            
            MapCompass()
        }
    }
    
    @ViewBuilder
    private func sheetBuilder(sheet: MapViewSheet) -> some View {
        switch sheet {
        case .mapTypeSelector:
            MapTypeSelectionView(mapStyle: $viewModel.mapStyle)
                .padding(Spacing.spacingM)
                .getHeight(height: $sheetHeight)
                .closeSheetHeader(title: R.string.localizable.chosseMap())
                .presentationDetents([.height(sheetHeight + 50)])
        case .baleSettings:
            BaleSettingsView(selectedCrop: $viewModel.selectedCrop, selectedBaleType: $viewModel.selectedBaleType)
                .closeSheetHeader(title: R.string.localizable.baleSettings())
                .presentationDetents([.fraction(0.3), .medium])
        case .balesNearYou:
            EmptyView()
        }
    }
}

#Preview("Dark") {
    MapView()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    MapView()
        .preferredColorScheme(.light)
}
