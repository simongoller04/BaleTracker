//
//  ErrorResponse.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.01.24.
//

import Foundation

enum ErrorResponse: String, Error, Codable, Equatable {
    // MARK: Login Errors
    case invalidPassword = "INVALID_PASSWORD"
    case invalidUsername = "INVALID_USERNAME"
    
    // MARK: Registration
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
        case .invalidPassword:
            return "The password is not correct!"
        case .invalidUsername:
            return "This user does not exist"
        case .usernameIsTaken:
            return "This username is already taken!"
        case .emailIsTaken:
            return "Email already exists"
        case .emailInvalid:
            return "This is not a valid email!"
        case .usernameTooShort:
            return "Username is to short!"
        case .passwordTooShort:
            return "Password is to short!"
        case .passwordsDoNotMatch:
            return "Passwords do not match!"
        case .userCreated, .none:
            return ""
        }
    }
}
