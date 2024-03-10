//
//  User.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: String
    let email: String
    let username: String
    let creationTime: String
    let lastEditingTime: String?
    let lastLoginTime: String?
    let imageKey: String?
    
    var imageUrl: URL? {
        guard let imageKey = imageKey else { return nil }
        let urlString = "http://localhost:8080/api/user/media/\(imageKey)/pic"
        return URL(string: urlString)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func toString() -> String {
        return """
            User ID: \(id)
            Email: \(email)
            Username: \(username)
            Creation Date: \(creationTime)
            Last Editing Time: \(lastEditingTime ?? "Unknown")
            Last Login Time: \(lastLoginTime ?? "Unknown")
            Image URL: \(imageUrl?.absoluteString ?? "Unknown")
        """
    }
}
