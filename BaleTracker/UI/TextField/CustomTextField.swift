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
    var font: Font = .body
    var isMultilineText: Bool = false
    var backgroundColor: Color = Color(uiColor: .systemBackground)
    var textalignment: TextAlignment = .leading
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            if isMultilineText {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .font(font)
                        .multilineTextAlignment(textalignment)
                        .focused($isFocused)
                        .padding(16)
                    if text.isEmpty {
                        Text(placeholder)
                            .font(font)
                            .foregroundStyle(Color(uiColor: .darkGray))
                            .padding(24)
                    }
                }
            } else {
                TextField(placeholder, text: $text)
                    .font(font)
                    .multilineTextAlignment(textalignment)
                    .focused($isFocused)
                    .padding(20)
            }
            
            border
        }
        .frame(height: isMultilineText ? 165 : 65)
    }
    
    private var border: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .stroke(isFocused ? Color.accentColor : Color.secondary, lineWidth: 1)
                .frame(height: isMultilineText ? 150 : 50)
            
            if isFocused {
                Text(placeholder)
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, Spacing.spacingXS)
                    .background(backgroundColor)
                    .padding(.leading, Spacing.spacingM)
                    .padding(.bottom, isMultilineText ? 150 : 50)
                    .fullWidth(.leading)
            }
        }
    }
}

#Preview("Dark") {
    VStack(spacing: 0) {
        CustomTextField(text: .constant(""), placeholder: "Username")
        CustomTextField(text: .constant(""), placeholder: "Email")
        CustomTextField(text: .constant(""), placeholder: "Email", font: .largeTitle, textalignment: .center)
        CustomTextField(text: .constant(""), placeholder: "Email", isMultilineText: true)
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
