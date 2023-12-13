//
//  UserApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation
import Moya

enum UserApi {
    case createUser(user: User)
    case getAllUser
//    case deleteUser
//    case editUser
}

extension UserApi: BaseTargetType {
    var path: String {
        switch self {
        case .createUser, .getAllUser:
            return "api/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        case .getAllUser:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createUser(user: let user):
            do {
                let jsonData = try JSONEncoder().encode(user)
                return .requestData(jsonData)
            } catch {
                return .requestPlain
            }
        case .getAllUser:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
