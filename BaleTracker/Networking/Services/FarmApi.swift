//
//  FarmApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import Moya

enum FarmApi {
    case createFarm(farm: Farm)
    case getAllFarms
    case getFarm(id: String)
}

extension FarmApi: BaseTargetType {
    var path: String {
        switch self {
        case .createFarm, .getAllFarms:
            return "/api/farm"
        case .getFarm(id: let id):
            return "api/farm/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createFarm:
            return .post
        case .getAllFarms, .getFarm:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createFarm(farm: let farm):
            do {
                let jsonData = try JSONEncoder().encode(farm)
                return .requestData(jsonData)
            } catch {
                return .requestPlain
            }
        case .getAllFarms, .getFarm:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
