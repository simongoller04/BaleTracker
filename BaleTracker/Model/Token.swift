//
//  Token.swift
//  BaleTracker
//
//  Created by Simon Goller on 16.12.23.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
