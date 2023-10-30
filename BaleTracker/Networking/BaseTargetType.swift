//
//  BaseTargetType.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.10.23.
//

import Foundation
import Moya

protocol BaseTargetType: Moya.TargetType {}

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }

    var sampleData: Data {
        return "".utf8Encoded
    }

    var authorizationHeader: [String: String]? {
//        if let accessToken = AuthenticationRepository.shared.token?.accessToken {
//            return ["Authorization": "Bearer \(accessToken)"]
//        }
        return nil
    }
}
