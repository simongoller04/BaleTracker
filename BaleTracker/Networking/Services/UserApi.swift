//
//  UserApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation
import Moya

enum UserApi {
    case getUser
    case deleteUser
//    case editUser
}

extension UserApi: BaseTargetType {
    var path: String {
        switch self {
        case .getUser:
            return "/api/user/me"
        case .deleteUser:
            return "/api/user/delete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .deleteUser:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUser, .deleteUser:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
