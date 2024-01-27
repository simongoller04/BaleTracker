//
//  LocationPermission.swift
//  BaleTracker
//
//  Created by Simon Goller on 21.12.23.
//

import Foundation
import CoreLocation

class LocationPermission: NSObject, ObservableObject {
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    var coordinates : CLLocationCoordinate2D?
    var location: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestLocationPermission()  {
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            break
        @unknown default:
            locationManager.requestAlwaysAuthorization()
        }
        authorizationStatus = manager.authorizationStatus
    }
}

extension LocationPermission: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        coordinates = location.coordinate
        self.location = location
    }
}
