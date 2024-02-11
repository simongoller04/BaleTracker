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
    case updateProfilePicture(image: Data)
    case deleteProfilePicture
}

extension UserApi: BaseTargetType {
    var path: String {
        switch self {
        case .getUser:
            return "/api/user/me"
        case .deleteUser:
            return "/api/user/delete"
        case .updateProfilePicture, .deleteProfilePicture:
            return "/api/user/media/pic"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .deleteUser, .deleteProfilePicture:
            return .delete
        case .updateProfilePicture:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUser, .deleteUser, .deleteProfilePicture:
            return .requestPlain
        case let .updateProfilePicture(image):
            let formData = MultipartFormData(provider: .data(image), name: "image", fileName: "image", mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        }
    }
    
    var headers: [String : String]? {
        return authorizationHeader
    }
}
