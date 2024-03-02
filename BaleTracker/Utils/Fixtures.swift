//
//  Fixtures.swift
//  BaleTracker
//
//  Created by Simon Goller on 06.11.23.
//

import Foundation
import MapKit

extension Farm {
    static func fixture(_with longDescription: Bool = false) -> Farm {
        if longDescription {
            return Farm(id: "id", name: "Farm 1",
                        description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibu",
                        coordinate: Coordinate(latitude: 0.0, longitude: 0.0), createdBy: "owner-id", creationTime: "2023-11-03T14:54:07.427Z", members: ["id-1", "id-2", "id-3"])
        } else {
            return Farm(id: "id", name: "Farm 1", description: "description", coordinate: Coordinate(latitude: 0.0, longitude: 0.0), createdBy: "owner-id", creationTime: "2023-11-03T14:54:07.427Z", members: ["id-1", "id-2", "id-3"])
        }
    }
}

extension User {
    static func fixture() -> User {
        return User(id: "id", email: "test@gmail.com", username: "simon", creationTime: "2023-11-03T14:54:07.427Z", lastEditingTime: nil, lastLoginTime: nil)
    }
    
    static func fixture(amount: Int) -> [User] {
        var users: [User] = []

        for _ in 0..<amount {
            users.append(.fixture())
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
        let createdBy = "creation_user"
        let collectedBy: String? = collected ? "collection_user" : nil
        let creationTime = "2023-11-03T14:54:07.427Z"
        let collectionTime: String? = collected ? "2023-11-03T14:54:07.427Z" : nil
        let coordinate = Coordinate(latitude: 13.405169, longitude: 52.518496)
        let farm = "farm1"

        return Bale(id: "id", crop: crop, baleType: baleType, createdBy: createdBy, creationTime: creationTime, collectedBy: collectedBy, collectionTime: collectionTime, coordinate: coordinate, farm: farm)
    }
}
