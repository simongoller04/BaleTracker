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
}

struct Farm: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String?
    let coordinate: Coordinate?
    let createdBy: String
    let creationTime: String
    let members: [String]?
    
    var imageUrl: URL? {
        let urlString = "http://localhost:8080/api/farm/media/\(id)/pic"
        return URL(string: urlString)
    }
    
    init(id: String, name: String, description: String?, coordinate: Coordinate?, createdBy: String, creationTime: String, members: [String]?) {
        self.id = id
        self.name = name
        self.description = description
        self.coordinate = coordinate
        self.createdBy = createdBy
        self.creationTime = creationTime
        self.members = members
    }
}
