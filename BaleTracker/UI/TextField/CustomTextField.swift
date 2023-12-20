//
//  CustomTextField.swift
//  BaleTracker
//
//  Created by Simon Goller on 13.12.23.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .padding(20)
            
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

#Preview("Dark") {
    VStack(spacing: 0) {
        CustomTextField(text: .constant(""), placeholder: "Username")
        CustomTextField(text: .constant(""), placeholder: "Email")
    }
    .darkPreview()
}

#Preview("Light") {
    Group {
        CustomTextField(text: .constant(""), placeholder: "Username")
        CustomTextField(text: .constant(""), placeholder: "Email")
    }
    .lightPreview()
}
