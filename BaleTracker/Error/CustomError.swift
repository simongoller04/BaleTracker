//
//  CustomError.swift
//  BaleTracker
//
//  Created by Simon Goller on 16.12.23.
//

import Alamofire
import Foundation
import Moya
import SwiftUI

enum CustomError: LocalizedError {
    case generic(message: String?)

    var errorDescription: String? {
        switch self {
        case .generic:
            return "Error:"
        }
    }

    var failureReason: String? {
        switch self {
        case .generic:
            return "Error:"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        default:
            return nil
        }
    }

    var image: SwiftUI.Image {
        switch self {
        default:
            return Image(systemName: "info.circle")
        }
    }

    /// If true, our error handler shows this as alert
    var shouldShow: Bool {
        switch self {
        default:
            return false
        }
    }
}
