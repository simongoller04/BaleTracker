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
    case login(loginDTO: UserLoginDTO)
}

extension AuthenticationApi: BaseTargetType {
    var path: String {
        switch self {
        case .register:
            return "/api/auth/register"
        case .login:
            return "/api/auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .register(user):
            return .requestJSONEncodable(user)
        case let .login(loginDTO):
            return .requestJSONEncodable(loginDTO)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

