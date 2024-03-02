//
//  PublicUserApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 11.02.24.
//

import Foundation
import Moya

enum PublicUserApi {
    case getUser(id: String)
    case getUsers(ids: [String])
}

extension PublicUserApi: BaseTargetType {
    var path: String {
        switch self {
        case .getUser(id: let id):
            return "/api/user/\(id)"
        case .getUsers:
            return "/api/user/multiple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .getUsers:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUser:
            return .requestPlain
        case .getUsers(ids: let ids):
            return .requestJSONEncodable(ids)
        }
    }
    
    var headers: [String : String]? {
        authorizationHeader
    }
}
