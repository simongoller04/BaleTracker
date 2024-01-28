//
//  TextFieldWithError.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.01.24.
//

import SwiftUI

struct TextFieldWithError<Content> : View where Content : View {
    @Binding var currentState: ErrorResponse
    var errorStates: [ErrorResponse]
    var textField: () -> Content
    
    var body: some View {
        VStack(spacing: 0) {
            textField()
            if errorStates.contains(where: { $0 == currentState }) {
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 14, height: 14)
                    

                    Text(currentState.errorMessage)
                        .font(.footnote)
                }
                .fullWidth(.leading)
                .foregroundStyle(.red)
            }
        }
    }
}

#Preview("Dark") {
    VStack {
        TextFieldWithError(currentState: .constant(ErrorResponse.invalidPassword), errorStates: [ErrorResponse.invalidPassword]) {
            CustomTextField(text: .constant("Test"), placeholder: "test")
        }
        
        TextFieldWithError(currentState: .constant(ErrorResponse.invalidUsername), errorStates: [ErrorResponse.invalidUsername]) {
            CustomTextField(text: .constant("Test"), placeholder: "test")
        }
        
        TextFieldWithError(currentState: .constant(ErrorResponse.invalidPassword), errorStates: [ErrorResponse.invalidUsername]) {
            CustomTextField(text: .constant("Test"), placeholder: "test")
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    VStack {
        TextFieldWithError(currentState: .constant(ErrorResponse.invalidPassword), errorStates: [ErrorResponse.invalidPassword]) {
            CustomTextField(text: .constant("Test"), placeholder: "test")
        }
        
        TextFieldWithError(currentState: .constant(ErrorResponse.invalidUsername), errorStates: [ErrorResponse.invalidUsername]) {
            CustomTextField(text: .constant("Test"), placeholder: "test")
        }
        
        TextFieldWithError(currentState: .constant(ErrorResponse.invalidPassword), errorStates: [ErrorResponse.invalidUsername]) {
            CustomTextField(text: .constant("Test"), placeholder: "test")
        }
    }
    .preferredColorScheme(.light)
}
