//
//  Bale.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Foundation
import SwiftUI
import MapKit

struct BaleCreate: Codable {
    var crop: Crop
    var baleType: BaleType
    var coordinate: Coordinate
    var farm: String?
}

struct Coordinate: Codable, Equatable, Hashable {
    var latitude: Double
    var longitude: Double
}

struct Bale: Codable, Hashable, Identifiable {
    var id: String
    var crop: Crop
    var baleType: BaleType
    var createdBy: String
    var creationTime: String
    var collectedBy: String?
    var collectionTime: String?
    var coordinate: Coordinate
    var farm: String?
    
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

enum Crop: String, Codable, Hashable, CaseIterable, Identifiable {
    case straw = "STRAW"
    case grass = "GRASS"
    case hay = "HAY"
    
    var id: Self { return self }
    var name: String {
        switch self {
        case .straw:
            return "Straw"
        case .grass:
            return "Grass"
        case .hay:
            return "Hay"
        }
    }
}

enum BaleType: String, Codable, Hashable, CaseIterable, Identifiable {
    case round = "ROUND"
    case square = "SQUARE"
    case round_wrapped = "ROUND_WRAPPED"
    case square_wrapped = "SQUARE_WRAPPED"
    
    var id: Self { return self }
    var name: String {
        switch self {
        case .round:
            return "Round"
        case .square:
            return "Square"
        case .round_wrapped:
            return "Round Wrapped"
        case .square_wrapped:
            return "Square Wrapped"
        }
    }
}
