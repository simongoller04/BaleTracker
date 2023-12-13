//
//  CreateNewFarmViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 07.11.23.
//

import Foundation
import UIKit
import Combine
import _MapKit_SwiftUI

class CreateNewFarmViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var selectedImage: UIImage? = nil
    @Published var members: [User] = []
    @Published var location: CLLocationCoordinate2D?
     
    @Published var cameraPosition: MapCameraPosition? 
//    {
//        get {
//            if let lat = location?.latitude,  let long = location?.longitude {
//                return .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)))
//            }
//            return nil
//        }
//        set {
//            newValue
//        }
//    }
    
    @Published var isFormValid = false
    
    private var subscriptions = Set<AnyCancellable>()

    init() {
        isNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &subscriptions)
    }
    
    // MARK: input validation
    
    var isNameValidPublisher: AnyPublisher<Bool, Never> {
        $name
            .map { name in
               let namePredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Za-z0-9 .-]{2,20}")
               return namePredicate.evaluate(with: name)
            }
            .eraseToAnyPublisher()
    }
}
