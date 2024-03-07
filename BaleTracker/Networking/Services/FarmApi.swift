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
    // get all farms that the current user is a member of, or is owner
    case getFarms
    // update the current profile picture of the farm
    case updateFarmPicture(id: String, image: Data)
    case deleteFarmPicture(id: String)
    // update values of the farm
    case updateFarm(id: String, farm: FarmUpdate)
}

extension FarmApi: BaseTargetType {
    var path: String {
        switch self {
        case .createFarm:
            return "/api/farm/create"
        case .getFarms:
            return "/api/farm"
        case .updateFarmPicture(id: let id, image: _), .deleteFarmPicture(id: let id):
            return "/api/farm/media/\(id)/pic"
        case .updateFarm(id: let id, farm: _):
            return "/api/farm/\(id)/update"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createFarm, .updateFarmPicture, .updateFarm:
            return .post
        case .getFarms:
            return .get
        case .deleteFarmPicture:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createFarm(farm: let farm):
            return .requestJSONEncodable(farm)
        case .getFarms, .deleteFarmPicture:
            return .requestPlain
        case let .updateFarmPicture(id: _, image: image):
            let formData = MultipartFormData(provider: .data(image), name: "image", fileName: "image", mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        case .updateFarm(id: _, farm: let farm):
            return .requestJSONEncodable(farm)
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
