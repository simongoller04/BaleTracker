//
//  UserDeletionResponse.swift
//  BaleTracker
//
//  Created by Simon Goller on 17.03.24.
//

import Foundation

enum UserDeletionResponse: String, Codable {
    case deleted = "DELETED"
    case notDeleted = "NOT_DELETED"
}
