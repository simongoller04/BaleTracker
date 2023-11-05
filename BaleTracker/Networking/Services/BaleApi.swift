//
//  BaleApi.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.10.23.
//

import Foundation
import Moya

enum BaleApi {
    // upload a bale to the api
    case uploadBale(bale: Bale)
    // fetch a bale for the api with the given id
    case getBale(id: String)
    // fetch all the bales form the api
    case getAllBales
}

extension BaleApi: BaseTargetType {
    var path: String {
        switch self {
        case .getAllBales, .uploadBale:
            return "/api/bale"
        case .getBale(id: let id):
            return "api/bale/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllBales, .getBale:
            return .get
        case .uploadBale:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllBales, .getBale:
            return .requestPlain
            
        case .uploadBale(bale: let bale):
            do {
                let jsonData = try JSONEncoder().encode(bale)
                return .requestData(jsonData)
            } catch {
                return .requestPlain
            }
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
