//
//  ViewModel.swift
//  BallenTracker
//
//  Created by Simon Goller on 27.07.22.
//

import Foundation
import CoreLocation
import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    @Published var isLogedIn: Bool = false
    
    @Published var currentBaleType: BaleType = .square
    @Published var currentCropType: CropType = .straw
    @Published var baleArray: [bale] = []
    @Published var baleCounter = 0
    
    func updateLoginStatus(success: Bool) {
        withAnimation {
            isLogedIn = success
        }
    }
}

struct bale: Hashable, Identifiable {
    var id = UUID()
    var number: Int
    var longitude: Double
    var latitude: Double
    var type: BaleType
    var crop: CropType
    var collected: Bool
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

//class bale: Identifiable {
//    var id: UUID
//    var number: Int = 0
//    var longitude: Double = 0.0
//    var latitude: Double = 0.0
//    var type: BaleType
//    var crop: CropType
//    var collected: Bool = false
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//    
//    init (number: Int, longitude: Double, latitude: Double, type: BaleType, crop: CropType, collected: Bool) {
//        self.id = UUID()
//        self.number = number
//        self.longitude = longitude
//        self.latitude = latitude
//        self.type = type
//        self.crop = crop
//        self.collected = collected
//    }
//}

enum BaleType {
    case round
    case square
    case wrappedRound
    case wrappedSquare
}

enum CropType {
    case hay
    case grass
    case grassSilge
    case cornSilage
    case straw
}

// return a string describing the type of bale
func handleBaleType(baleType: BaleType) -> String {
    switch baleType {
        case .round:
            return "Round"
        case .square:
            return "Square"
        case .wrappedRound:
            return "Wrapped Round"
        case .wrappedSquare:
            return "Wrapped Square"
    }
}

// return a string describing the type of the crop
func handleCropType(cropType: CropType) -> String {
    switch cropType {
    case .hay:
        return "Hay"
    case .grass:
        return "Grass"
    case .grassSilge:
        return "Grass Silage"
    case .cornSilage:
        return "Corn Silage"
    case .straw:
        return "Straw"
    }
}
