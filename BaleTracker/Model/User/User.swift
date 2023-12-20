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
    let password: String
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
