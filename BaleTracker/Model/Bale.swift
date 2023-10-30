//
//  Bale.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Foundation

struct Bale: Decodable, Encodable {
    let id: String
    let crop: String
    let baleType: String 
    let user: String
    let longitude: Double
    let latitude: Double
}
