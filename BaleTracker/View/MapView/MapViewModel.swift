//
//  MapViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import _MapKit_SwiftUI

class MapViewModel: ObservableObject {
    @Published var mapStyle: MapStyle = .standard
    @Published var selectedCrop: Crop = .straw
    @Published var selectedBaleType: BaleType = .round
}
