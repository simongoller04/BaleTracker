//
//  User.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let username: String
    
    var imageUrl: URL? {
        let urlString = "http://localhost:8080/api/user/media/\(id)/pic"
        return URL(string: urlString)
    }
//    let firstName: String
//    let lastName: String
//    let dateOfBirth: String
//    var profilePicture: Data?
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
