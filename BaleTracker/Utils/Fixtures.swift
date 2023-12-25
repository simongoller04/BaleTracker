//
//  Fixtures.swift
//  BaleTracker
//
//  Created by Simon Goller on 06.11.23.
//

import Foundation
import MapKit

extension Farm {
    static func fixture() -> Farm {
        return Farm(id: "id", name: "Farm 1", owner: "owner-id", creationTime: "2023-11-03T14:54:07.427Z", members: ["id-1", "id-2", "id-3"])
    }
}

extension User {
    static func fixture() -> User {
        return User(id: "id", email: "test@gmail.com", username: "simon", password: "1234")
    }
    
    static func fixture(amount: Int) -> [User] {
        var users: [User] = []

        for _ in 0..<amount {
            let user = User(id: "id", email: "test@gmail.com", username: "simon", password: "1234")
            users.append(user)
        }

        return users
    }
}

extension CLLocationCoordinate2D {
    static func fixture() -> CLLocationCoordinate2D {
        /// Coordinates of vienna
        return CLLocationCoordinate2D(latitude: 48.210033, longitude: 16.363449)
    }
}

extension Bale {
    static func fixture(collected: Bool = false) -> Bale {
        let crop = Crop.straw
        let baleType = BaleType.round
        let createdBy = "created-by-id"
        var collectedBy: String? = collected ? "id" : nil
        let creationTime = "2023-11-03T14:54:07.427Z"
        let longitude = 52.518496
        let latitude = 13.405169

        return Bale(id: "id", crop: crop, baleType: baleType, createdBy: createdBy, collectedBy: collectedBy, creationTime: creationTime, collectionTime: nil, longitude: longitude, latitude: latitude)
    }
}
