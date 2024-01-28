//
//  RegistrationView.swift
//  BaleTracker
//
//  Created by Simon Goller on 15.12.23.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 24) {
            LogoHeader()
            
            VStack(spacing: 0) {
                TextFieldWithError(currentState: $viewModel.registrationState, errorStates: [.emailInvalid, .emailIsTaken]) {
                    CustomTextField(text: $viewModel.email, placeholder: "Email")
                }
                TextFieldWithError(currentState: $viewModel.registrationState, errorStates: [.usernameIsTaken, .usernameTooShort]) {
                    CustomTextField(text: $viewModel.username, placeholder: "Username")
                }
                TextFieldWithError(currentState: $viewModel.registrationState, errorStates: [.passwordTooShort]) {
                    CustomSecureTextField(text: $viewModel.password, placeholder: "Password")
                }
                TextFieldWithError(currentState: $viewModel.registrationState, errorStates: [.passwordsDoNotMatch]) {
                    CustomSecureTextField(text: $viewModel.repeatPassword, placeholder: "Repeat Password")
                }
            }
            
            ActionButton(isDisabled: !viewModel.isFormValid, text: "Sign up") {
                viewModel.register() {
                    if viewModel.registrationState == .userCreated {
                        path.append(RegistrationFLowNavigationItem.successfulRegistrationView)
                    }
                }
            }
        }
        .padding(Spacing.spacingM)
        .navigationBarTitleDisplayMode(.inline)
        .textInputAutocapitalization(.never)
    }
}

#Preview("Light") {
    RegistrationView(path: .constant(NavigationPath()))
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    RegistrationView(path: .constant(NavigationPath()))        .preferredColorScheme(.dark)
}
