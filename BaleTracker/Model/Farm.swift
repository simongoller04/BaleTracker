//
//  Farm.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation

struct Farm: Codable {
    let id: String?
    let name: String
    let owner: String
    let creationTime: String
    let members: [String]
}
