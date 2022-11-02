//
//  MapView.swift
//  BallenTracker
//
//  Created by Simon Goller on 27.07.22.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation
import HalfASheet

struct MapView: View {
    
    @StateObject var locationViewModel = LocationViewModel()
    @EnvironmentObject var viewModel: ViewModel
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State var mapType = MKMapType.hybrid
    @State private var showPopOver = false
    @State private var showSheet = false
    @State private var selectedBale: bale? = nil
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $locationViewModel.mapRegion,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: viewModel.baleArray,
                annotationContent: { bale in
                    MapAnnotation(coordinate: bale.coordinate) {
                        Circle()
                            .strokeBorder(bale.collected ? .green : .yellow, lineWidth: 6)
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                selectedBale = bale
                            }
                    }
                }
            )
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                locationViewModel.checkIfLocationServicesIsEnabled()
            }
            
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        // add action
                    }, label: {
                        Image(systemName: "globe.europe.africa.fill")
                            .foregroundColor(Color.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black)
                    })
                    .cornerRadius(10)
                    .padding([.top, .trailing], 20)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.showPopOver = true
                    }, label: {
                        Image(systemName: "list.dash")
                            .foregroundColor(Color.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black)
                    })
                    .cornerRadius(10)
                    .padding([.trailing], 20)
                }
                
                Spacer()
                
                Button (action: {
                    createBaleForLocation()
                }, label: {
                    Label("Add bale", systemImage: "plus.circle.fill")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                })
                .padding([.leading, .trailing, .bottom], 16)
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            }
        }
        .sheet(item: $selectedBale) { bale in
            DetailedBaleView(bale: bale)
                .presentationDetents([.fraction(0.62), .fraction(0.80)])
        }
        
        .popover(isPresented: $showPopOver) {
            ListView(showPopOver: $showPopOver)
        }
    }
    
    func createBaleForLocation() {
        guard let lat = locationViewModel.locationManager?.location?.coordinate.latitude else {
            return
        }
        
        guard let long = locationViewModel.locationManager?.location?.coordinate.longitude else {
            return
        }
        
        viewModel.baleCounter += 1
        
        viewModel.baleArray.append(bale(number: viewModel.baleCounter,
                                        longitude: long,
                                        latitude: lat,
                                        type: viewModel.currentBaleType,
                                        crop: viewModel.currentCropType,
                                        collected: false))
    }
}

//struct mapKitView: UIViewRepresentable {
//    typealias UIViewType = MKMapView
//
//    func makeUIView(context: Context) -> MKMapView {
//        <#code#>
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        <#code#>
//    }
//}
