//
//  CustomSecureTextField.swift
//  BaleTracker
//
//  Created by Simon Goller on 13.12.23.
//

import SwiftUI

struct CustomSecureTextField: View {
    @Binding var text: String
    var placeholder: String
    
    @FocusState private var isFocused: Bool
    @State private var showPassword = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if showPassword {
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .padding(20)
            } else {
                SecureField(placeholder, text: $text)
                    .focused($isFocused)
                    .padding(20)
            }
        
            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(Color.accentColor)
            }
            .padding(Spacing.spacingM)
            
            border
        }
        .frame(height: 65)
    }
    
    private var border: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .stroke(isFocused ? Color.accentColor : Color.secondary, lineWidth: 1)
                .frame(height: 50)
            
            if isFocused {
                Text(placeholder)
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, Spacing.spacingXS)
                    .background(Color(uiColor: UIColor.systemBackground))
                    .padding(.leading, Spacing.spacingM)
                    .padding(.bottom, 50)
                    .fullWidth(.leading)
            }
        }
    }
}

#Preview("Light"){
    Group {
        CustomSecureTextField(text: .constant(""), placeholder: "Password")
        CustomSecureTextField(text: .constant(""), placeholder: "Repeat Password")
    }
    .preferredColorScheme(.light)
}

#Preview("Dark"){
    Group {
        CustomSecureTextField(text: .constant(""), placeholder: "Password")
        CustomSecureTextField(text: .constant(""), placeholder: "Repeat Password")
    }
    .preferredColorScheme(.dark)
}
