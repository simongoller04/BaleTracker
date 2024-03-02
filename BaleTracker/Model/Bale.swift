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
            return R.string.localizable.crop_straw()
        case .grass:
            return R.string.localizable.crop_grass()
        case .hay:
            return R.string.localizable.crop_hay()
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
            return R.string.localizable.baleType_round()
        case .square:
            return R.string.localizable.baleType_square()
        case .round_wrapped:
            return R.string.localizable.baleType_round_wrapped()
        case .square_wrapped:
            return R.string.localizable.baleType_square_wrapped()
        }
    }
}
