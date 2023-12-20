//
//  CustomSocialButton.swift
//  BaleTracker
//
//  Created by Simon Goller on 14.12.23.
//

import SwiftUI

struct CustomSocialButton: View {
    var isLoading: Bool
    var image: Image
    var imageColor: Color? = nil
    var text: String
    var imageSize: CGFloat = 16
    var buttonHeight: CGFloat = 50
    var textColor: Color = .white
    var backgroundColor: Color = .black
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.white)
                } else {
                    HStack {
                        if let imageColor {
                            image
                                .renderingMode(.template)
                                .foregroundColor(imageColor)
                                .frame(width: imageSize, height: imageSize)
                        } else {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize, height: imageSize)
                        }

                        Text(text)
                            .foregroundStyle(textColor)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(minHeight: 50)
        }
        .disabled(isLoading)
        .frame(height: buttonHeight)
        .background(backgroundColor)
        .cornerRadius(14)
    }
}

#Preview {
    CustomSocialButton(isLoading: false,
                       image: Image(systemName: "apple.logo"),
                       imageColor: .white,
                       text: "Continue with Apple")
}
