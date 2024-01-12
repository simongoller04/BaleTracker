//
//  KFImage+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.01.24.
//

import Foundation
import Kingfisher

extension KFImage {
    static var authorizationModifier: AnyModifier {
        return AnyModifier { request in
            var request = request
            if let authToken = AuthenticationRepositoryImpl.shared.token?.accessToken {
                request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            }
            return request
        }
    }
}
