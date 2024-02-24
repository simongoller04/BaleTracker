//
//  CLLocationCoordinate2D+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 24.02.24.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    func toCoordinate() -> Coordinate {
        return Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
    
    func toString() -> String {
        return "lat: \(self.latitude.rounded(toPlaces: 3)), long: \(self.longitude.rounded(toPlaces: 3))"
    }
    
    func getAddress() -> String {
        // TODO: does not work yet
        let decoder = CLGeocoder()
        var address: String = ""
        decoder.reverseGeocodeLocation(self.toCLLocation()) { places, error in
            if error == nil {
                address = places?.first?.name ?? "no value"
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
        return address
    }
}
