//
//  SelectFarmLocationViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.11.23.
//

import Foundation
import MapKit
import SwiftUI

class SelectFarmLocationViewModel: ObservableObject {
    @Binding var position: MapCameraPosition?
    @State var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)))
    
    init(position: Binding<MapCameraPosition?>) {
        _position = position
    }
}
