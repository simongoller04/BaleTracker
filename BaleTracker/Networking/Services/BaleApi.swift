//
//  BaleApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.10.23.
//

import Foundation
import Moya

enum BaleApi {
    case createBale(bale: BaleCreate)
    case collectBale(id: String)
    // get all bales created by the currently authenticated user
    case getCreated
    // get all bales collected by the currently authenticated user
    case getCollected
    // get all the bales form a farm
    case getAllFromFarm(farmId: String)
    // get all bales created or collected by the currently authenticated user
    case getAllBales
    case query(query: BaleQuery)
}

extension BaleApi: BaseTargetType {
    var path: String {
        switch self {
        case .createBale:
            return "/api/bale/create"
        case .collectBale(id: let id):
            return "/api/bale/collect/\(id)"
        case .getAllBales:
            return "/api/bale/get/all"
        case .getCreated:
            return "/api/bale/get/created"
        case .getCollected:
            return "/api/bale/get/collected"
        case .getAllFromFarm(farmId: let farmId):
            return "/api/bale/get/all/farm/\(farmId)"
        case .query:
            return "/api/bale/query"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllBales, .getAllFromFarm, .getCollected, .getCreated:
            return .get
        case .collectBale:
            return .put
        case .createBale, .query:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createBale(bale: let bale):
            return .requestJSONEncodable(bale)
        case .collectBale, .getAllBales, .getAllFromFarm, .getCollected, .getCreated:
            return .requestPlain
        case .query(query: let query):
            return .requestJSONEncodable(query)
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
