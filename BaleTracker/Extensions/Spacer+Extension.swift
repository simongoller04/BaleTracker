//
//  Spacer+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.07.23.
//

import SwiftUI

struct Spacing {
    /// Spacing 2 CGFloat
    static let spacingXXS: CGFloat = 2
    /// Spacing 4 CGFloat
    static let spacingXS: CGFloat = 4
    /// Spacing 8 CGFloat
    static let spacingS: CGFloat = 8
    /// Spacing 16 CGFloat
    static let spacingM: CGFloat = 16
    /// Spacing 24 CGFloat
    static let spacingL: CGFloat = 24
    /// Spacing 32 CGFloat
    static let spacingXL: CGFloat = 32
    /// Spacing 40 CGFloat
    static let spacing2XL: CGFloat = 40
    /// Spacing 48 CGFloat
    static let spacing3XL: CGFloat = 48
    /// Spacing 56 CGFloat
    static let spacing4XL: CGFloat = 56
    /// Spacing 64 CGFloat
    static let spacing5XL: CGFloat = 64
    /// Spacing 72 CGFloat
    static let spacing6XL: CGFloat = 72
}

extension Spacer {
    /// Returns a fixed size width spacer with given spacing
    static func width(_ width: CGFloat) -> some View {
        Spacer()
            .frame(width: width)
    }

    /// Returns a fixed size height spacer with given spacing
    static func height(_ height: CGFloat) -> some View {
        Spacer()
            .frame(height: height)
    }
}
