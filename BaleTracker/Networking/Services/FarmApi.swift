//
//  FarmApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import Moya

enum FarmApi {
    // create a new farm
    case createFarm(farm: FarmCreate)
    // get all farms that the current user is a member of
    case getFarms
}

extension FarmApi: BaseTargetType {
    var path: String {
        switch self {
        case .createFarm:
            return "/api/farm/create"
        case .getFarms:
            return "api/farm"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createFarm:
            return .post
        case .getFarms:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createFarm(farm: let farm):
            return .requestJSONEncodable(farm)
        case .getFarms:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
