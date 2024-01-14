//
//  LogoutUseCase.swift
//  BaleTracker
//
//  Created by Simon Goller on 30.12.23.
//

import Foundation
import Kingfisher

final class LogoutUseCase {
    func execute() {
        KeyChain.delete(key: .token)
        KeyChain.clear()
        AuthenticationRepositoryImpl.shared.clear()

        UserDefaults.resetStandardUserDefaults()

        // reset app storage
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }

        KingfisherManager.shared.cache.clearCache()
    }
}
