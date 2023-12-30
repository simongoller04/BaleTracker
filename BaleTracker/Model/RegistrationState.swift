//
//  RegistrationState.swift
//  BaleTracker
//
//  Created by Simon Goller on 29.12.23.
//

import Foundation

enum RegistrationState: String, Codable {
    case usernameIsTaken = "USERNAME_TAKEN"
    case emailIsTaken = "EMAIL_TAKEN"
    case userCreated = "USER_CREATED"
    case emailInvalid
    case usernameTooShort
    case passwordTooShort
    case passwordsDoNotMatch
    case none
    
    var errorMessage: String {
        switch self {
        case .usernameIsTaken:
            return "This username is already taken!"
        case .emailIsTaken:
            return "Email already exists"
        case .userCreated, .none:
            return ""
        case .emailInvalid:
            return "This is not a valid email!"
        case .usernameTooShort:
            return "Username is to short!"
        case .passwordTooShort:
            return "Password is to short!"
        case .passwordsDoNotMatch:
            return "Passwords do not match!"
        }
    }
}
