//
//  Bale.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Foundation
import SwiftUI

struct Bale: Codable {
    var id: String?
    var crop: Crop
    var baleType: BaleType
    var createdBy: String
    var collectedBy: String
    var creationTime: String
    var collectionTime: String
    var longitude: Double
    var latitude: Double
}

enum Crop: String, Codable {
    case STRAW = "STRAW"
    case GRASS = "GRASS"
    case HAY = "HAY"
}

enum BaleType: String, Codable {
    case ROUND
    case SQUARE
    case ROUND_WRAPPED
    case SQUARE_WRAPPED
}
