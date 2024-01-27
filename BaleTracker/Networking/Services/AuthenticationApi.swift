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
    case refresh(token: RefreshToken)
}

extension AuthenticationApi: BaseTargetType {
    var path: String {
        switch self {
        case .register:
            return "/api/auth/register"
        case .login:
            return "/api/auth/login"
        case .refresh:
            return "/api/auth/refreshToken"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .login, .refresh:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .register(user):
            return .requestJSONEncodable(user)
        case let .login(loginDTO):
            return .requestJSONEncodable(loginDTO)
        case let .refresh(token):
            return .requestJSONEncodable(token)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

