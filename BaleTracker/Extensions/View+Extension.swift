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

//    func handle(_ error: Binding<Error?>, type: ErrorHandlingType = .alert()) -> some View {
//        modifier(ErrorHandlingViewModifier(error: error, type: type))
//    }

    func lightPreview(_ state: String = "") -> some View {
        return modifier(LightPreviewModifier(state: state))
    }

    func darkPreview(_ state: String = "") -> some View {
        return modifier(DarkPreviewModifier(state: state))
    }

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
    
    func getHeight(height: Binding<CGFloat>) -> some View {
        modifier(GetHeightModifier(height: height))
    }
    
    func closeSheetHeader(title: String = "") -> some View {
        modifier(CloseSheetHeaderModifier(title: title))
    }
    
    func baleDeletionAlert(showAlert: Binding<Bool>, presenting: Bale?, onClick: @escaping (String) -> ()) -> some View {
        modifier(BaleDeletionAlert(showAlert: showAlert, presenting: presenting, onClick: onClick))
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

private struct CloseSheetHeaderModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    var title: String
    
    func body(content: Content) -> some View {
        NavigationView {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(title)
                            .font(.headline)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.primary)
                        .font(.system(size: 20))
                    }
                }
        }
    }
}

private struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

struct BaleDeletionAlert: ViewModifier {
    @Binding var showAlert: Bool
    var presenting: Bale?
    var onClick: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .alert(R.string.localizable.deleteBale_title(), isPresented: $showAlert, presenting: presenting) { bale in
                Button(R.string.localizable.delete(), role: .destructive) {
                    onClick(bale.id)
                    dismiss()
                }
                Button(R.string.localizable.cancel(), role: .cancel) {
                    showAlert = false
                }
            } message: { _ in
                Text(R.string.localizable.deleteBale_message())
            }
    }
}
