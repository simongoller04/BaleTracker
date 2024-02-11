//
//  MapView.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import SwiftUI
import MapKit

enum MapViewSheet: Hashable, Identifiable {
    case mapTypeSelector
    case baleSettings
    case balesNearYou
    case baleDetails(bale: Bale)
    
    var id: Self { return self }
}

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @StateObject private var locationPermission = LocationPermission()
    
    @State private var activeSheet: MapViewSheet?
    @State private var sheetHeight: CGFloat = .infinity

    @Namespace private var mapScope
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(scope: mapScope) {
                if let bales = viewModel.bales {
                    ForEach(bales, id: \.id) { bale in
                        Annotation("", coordinate: bale.locationCoordinate) {
                            Button {
                                activeSheet = .baleDetails(bale: bale)
                            } label: {
                                BaleAnnotation(bale: bale)
                            }
                        }
                    }
                }
            }
            .mapControlVisibility(.hidden)
            .mapStyle(viewModel.mapStyle)
            .ignoresSafeArea()
            
            buttonList
                .padding(Spacing.spacingM)
            
            HStack {
                ActionButton(text: R.string.localizable.addBale(), image: Image(systemName: "plus")) {
                    viewModel.createBale()
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
        HStack(alignment: .top) {
            MapScaleView(scope: mapScope)
                .fullWidth(.leading)
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
                        Image(systemName: "checklist")
                            .frame(width: Spacing.spacing2XL, height: Spacing.spacing2XL)
                    }
                }
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(10)
                .frame(width: Spacing.spacing2XL)
                
                MapCompass(scope: mapScope)
            }
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
            BalesNearYouView()
                .closeSheetHeader(title: "Bales")
                .presentationDetents([.fraction(0.3), .medium, .large])
                .environmentObject(locationPermission)
        case .baleDetails(bale: let bale):
            BaleDetailView(viewModel: BaleDetailViewModel(bale: bale))
                .closeSheetHeader(title: "Details")
                .presentationDetents([.medium, .large])
                .environmentObject(locationPermission)
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
