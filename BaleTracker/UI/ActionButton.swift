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
    
    var body: some View {
        Button {
            if !isLoading {
                onClick()
            }
        } label: {
            if isLoading {
                ProgressView()
                    .fullWidth()
                    .frame(height: 40)
                    .tint(Color.white)
            } else {
                Text(text)
                    .bold()
                    .fullWidth()
                    .frame(height: 40)
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(isDisabled)
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

