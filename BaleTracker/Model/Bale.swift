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
    var collectedBy: String?
    var creationTime: String
    var collectionTime: String?
    var longitude: Double
    var latitude: Double
}

enum Crop: String, Codable, Hashable, CaseIterable, Identifiable {
    case straw = "Straw"
    case grass = "Grass"
    case hay = "Hay"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue }
    
}

enum BaleType: String, Codable, Hashable, CaseIterable, Identifiable {
    case round = "Round"
    case square = "Square"
    case round_wrapped = "Round Wrapped"
    case square_wrapped = "Square Wrapped"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue }
}
