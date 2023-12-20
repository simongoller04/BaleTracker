//
//  ActionButton.swift
//  BaleTracker
//
//  Created by Simon Goller on 11.11.23.
//

import SwiftUI

struct ActionButton: View {
    var isLoading = false
    var text = "Press me"
    var isDisabled = false
    var onClick: () -> Void
    var buttonHeight: CGFloat = 50
    var textColor: Color = .white
    var backgroundColor: Color = .accentColor
    
    var body: some View {
        Button {
            if !isLoading {
                onClick()
            }
        } label: {
            if isLoading {
                ProgressView()
                    .fullWidth()
                    .tint(textColor)
            } else {
                Text(text)
                    .bold()
                    .foregroundStyle(textColor)
                    .fullWidth()
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
        }
        .lightPreview()
        
        VStack {
            ActionButton(isLoading: true, text: "Action Button") {}
            ActionButton(isLoading: false, text: "Action Button") {}
        }
        .darkPreview()
    }
}

