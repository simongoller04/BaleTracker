//
//  ActionButton.swift
//  BaleTracker
//
//  Created by Simon Goller on 11.11.23.
//

import SwiftUI

struct ActionButton: View {
    var isLoading = false
    var isDisabled = false
    var text: String?
    var image: Image?
    var buttonHeight: CGFloat = 50
    var buttonWidth: CGFloat = .infinity
    var textColor: Color = .white
    var backgroundColor: Color = .accentColor
    var onClick: () -> Void
    
    var body: some View {
        Button {
            if !isLoading {
                onClick()
            }
        } label: {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: buttonWidth)
                    .tint(textColor)
            } else {
                HStack {
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                    
                    if let text = text {
                        Text(text)
                            .bold()
                    }
                }
                .foregroundStyle(textColor)
                .frame(maxWidth: buttonWidth)
            }
        }
        .disabled(isDisabled)
        .frame(height: buttonHeight)
        .background(backgroundColor)
        .cornerRadius(14)
    }
}

struct ActionButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ActionButton(isLoading: true, text: "Action Button") {}
            ActionButton(isLoading: false, text: "Action Button") {}
            ActionButton(isLoading: false, image: Image(systemName: "gear")) {}
        }
        .lightPreview()
        
        VStack {
            ActionButton(isLoading: true, text: "Action Button") {}
            ActionButton(isLoading: false, text: "Action Button") {}
            ActionButton(isLoading: false, image: Image(systemName: "gear")) {}
        }
        .darkPreview()
    }
}

