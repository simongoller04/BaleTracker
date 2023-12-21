//
//  RegistrationView.swift
//  BaleTracker
//
//  Created by Simon Goller on 15.12.23.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var showScreenCover = false
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 24) {
            LogoHeader()
            
            VStack(spacing: 0) {
                textFieldWithError(errorMessage: "This is not a valid email!", showError: !viewModel.isEmailValid) {
                    CustomTextField(text: $viewModel.email, placeholder: "Email")
                }
                textFieldWithError(errorMessage: "Username is to short!", showError: !viewModel.isUsernameValid) {
                    CustomTextField(text: $viewModel.username, placeholder: "Username")
                }
                textFieldWithError(errorMessage: "Password is to short!", showError: !viewModel.isPasswordValid) {
                    CustomSecureTextField(text: $viewModel.password, placeholder: "Password")
                }
                textFieldWithError(errorMessage: "Passwords do not match!", showError: !viewModel.isRepeatPasswordValid) {
                    CustomSecureTextField(text: $viewModel.repeatPassword, placeholder: "Repeat Password")
                }
            }
            
            ActionButton(text: "Sign up", isDisabled: !viewModel.isFormValid) {
                viewModel.register()
                path.append(RegistrationFLowNavigationItem.successfulRegistrationView)
            }
        }
        .padding(Spacing.spacingM)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func textFieldWithError(errorMessage: String, showError: Bool, textField: () -> some View) -> some View {
        VStack(spacing: 0) {
            textField()
            if showError {
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 14, height: 14)
                    

                    Text(errorMessage)
                        .font(.footnote)
                }
                .fullWidth(.leading)
                .foregroundStyle(.red)
            }
        }
    }
}

#Preview("Light") {
    RegistrationView(path: .constant(NavigationPath()))
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    RegistrationView(path: .constant(NavigationPath()))        .preferredColorScheme(.dark)
}
