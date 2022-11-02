//
//  LocationViewModel.swift
//  BallenTracker
//
//  Created by Simon Goller on 07.08.22.
//

import Foundation
import CoreLocation
import MapKit

class LocationViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {

    @Published var longitude: Double = 0
    @Published var latitude: Double = 0
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager()
                self.locationManager!.delegate = self
            }
            
            else {
                print("Location needs to be enabled!")
            }
        }

    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            case .restricted:
                print("Location permission is retricted")
            
            case .denied:
                print("Location permission is denied")
            
            case .authorizedAlways, .authorizedWhenInUse:
            mapRegion = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                           span:  MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            
            @unknown default:
                break
        }
    }
    
    // is called when the authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print ("test")
        
        guard let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        self.longitude = longitude
        
        guard let latitude = locations.last?.coordinate.latitude else {
            return
        }
        
        self.latitude = latitude
        
        checkLocationAuthorization()
    }
}
