//
//  View+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.07.23.
//

import SwiftUI

extension View {
    func fullWidth(_ alignment: Alignment = .center) -> some View {
        modifier(FullWidthModifier(alignment: alignment))
    }

    func fullHeight(_ alignment: Alignment = .center) -> some View {
        modifier(FullHeightModifier(alignment: alignment))
    }

    func handle(_ error: Binding<Error?>, type: ErrorHandlingType = .alert()) -> some View {
        modifier(ErrorHandlingViewModifier(error: error, type: type))
    }

    func lightPreview(_ state: String = "") -> some View {
        return modifier(LightPreviewModifier(state: state))
    }

    func darkPreview(_ state: String = "") -> some View {
        return modifier(DarkPreviewModifier(state: state))
    }

//    func appBackground() -> some View {
//        return modifier(AppBackground())
//    }
//
//    func appBackgroundDark() -> some View {
//        return modifier(AppBackgroundDark())
//    }
//
//    func appBackgroundLight() -> some View {
//        return modifier(AppBackgroundLight())
//    }

    func appShadow() -> some View {
        return shadow(color: Color.black.opacity(0.05), radius: Spacing.spacingS, y: 2.0)
    }

    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
    
    func previewAllColorSchemes(title: String = "") -> some View {
        modifier(ColorSchemeModifier(title: title))
    }
}

private struct FullWidthModifier: ViewModifier {
    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

private struct FullHeightModifier: ViewModifier {
    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}

private struct LightPreviewModifier: ViewModifier {
    let state: String

    func body(content: Content) -> some View {
        content
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName(state.isEmpty ? "iPhone 14 (Light)" : "iPhone 14 (Light) - \(state)")
            .preferredColorScheme(.light)
    }
}

private struct DarkPreviewModifier: ViewModifier {
    let state: String

    func body(content: Content) -> some View {
        content
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName(state.isEmpty ? "iPhone 14 (Dark)" : "iPhone 14 (Dark) - \(state)")
            .preferredColorScheme(.dark)
    }
}

private struct ColorSchemeModifier: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            content
                .previewDisplayName(title + " \(colorScheme)".capitalized + " Mode")
                .preferredColorScheme(colorScheme)
        }
    }
}

//private struct AppBackground: ViewModifier {
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
//
//    func body(content: Content) -> some View {
//        if colorScheme == .light {
//            return content
//                .background(R.color.backgroundLight.color)
//        } else {
//            return content
//                .background(R.color.backgroundDark.color)
//        }
//    }
//}
//
//private struct AppBackgroundDark: ViewModifier {
//    func body(content: Content) -> some View {
//        return content
//            .background(R.color.backgroundDark.color)
//    }
//}
//
//private struct AppBackgroundLight: ViewModifier {
//    func body(content: Content) -> some View {
//        return content
//            .background(R.color.backgroundLight.color)
//    }
//}
