//
//  MediaRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.01.24.
//

import Foundation
import Kingfisher
import UIKit

class MediaRepository {
    func getImageWithUrl(url: URL?, closure: @escaping (UIImage?) -> Void) {
        KingfisherManager.shared.cache.clearCache()
        if let url = url {
            KingfisherManager.shared.retrieveImage(with: url, options: [.requestModifier(KFImage.authorizationModifier)]) { result in
                switch result {
                case .success(let image):
                    "Image fetched sucessfully".log(.info)
                    if let data = image.data() {
                        closure(UIImage(data: data))
                    }
                case .failure(_):
                    "Failed to fetch image".log(.error)
                    closure(nil)
                }
            }
        }
    }
}
