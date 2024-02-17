//
//  Farm.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation

struct FarmCreate: Codable {
    let name: String
    let description: String?
    let coordinate: Coordinate?
    let members: [String]?
    var image: Data?
}

struct Farm: Codable {
    let id: String?
    let name: String
    let description: String?
    let coordinate: Coordinate?
    let createdBy: String
    let creationTime: String
    let members: [String]
}
