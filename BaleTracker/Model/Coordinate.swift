//
//  Coordinate.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.02.24.
//

import Foundation
import MapKit

struct Coordinate: Codable, Equatable, Hashable {
    var latitude: Double
    var longitude: Double
    
    func toMKCoordinateRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude),
                                  span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    }
}
