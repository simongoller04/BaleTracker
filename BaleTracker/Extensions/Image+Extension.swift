//
//  Image+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 10.11.23.
//

import Foundation
import SwiftUI

extension Image {
    init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self = .init(uiImage: image)
    }
}
