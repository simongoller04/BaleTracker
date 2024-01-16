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
    case getBale(id: String)
    // get all bales created by the currently authenticated user
    case getAllBales
}

extension BaleApi: BaseTargetType {
    var path: String {
        switch self {
        case .createBale:
            return "/api/bale/create"
        case .collectBale(id: let id):
            return "/api/bale/collect/\(id)"
        case .getBale(id: let id):
            return "api/bale/\(id)"
        case .getAllBales:
            return "api/bale/getAll"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBale, .getAllBales:
            return .get
        case .collectBale:
            return .put
        case .createBale:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createBale(bale: let bale):
            return .requestJSONEncodable(bale)
        case .collectBale, .getBale, .getAllBales:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
