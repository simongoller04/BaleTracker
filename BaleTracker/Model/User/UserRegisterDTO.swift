//
//  UserCreate.swift
//  BaleTracker
//
//  Created by Simon Goller on 15.12.23.
//

import Foundation

struct UserRegisterDTO: Encodable {
    let email: String
    let username: String
    let password: String
}
