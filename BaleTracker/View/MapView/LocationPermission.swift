//
//  LocationPermission.swift
//  BaleTracker
//
//  Created by Simon Goller on 21.12.23.
//

import Foundation
import CoreLocation

class LocationPermission: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    private let locationManager = CLLocationManager()
    @Published var cordinates : CLLocationCoordinate2D?
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        cordinates = location.coordinate
    }
}
