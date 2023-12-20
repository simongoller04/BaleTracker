//
//  AuthenticationApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 15.12.23.
//

import Foundation
import Moya

enum AuthenticationApi {
    case register(user: UserRegisterDTO)
//    case login(username: String, password: String)
}

extension AuthenticationApi: BaseTargetType {
    var path: String {
        switch self {
        case .register:
            return "/api/auth/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .register(user):
            return .requestJSONEncodable(user)
//            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}

