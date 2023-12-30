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
                textFieldWithError(errorStates: [.emailInvalid, .emailIsTaken]) {
                    CustomTextField(text: $viewModel.email, placeholder: "Email")
                }
                textFieldWithError(errorStates: [.usernameIsTaken, .usernameTooShort]) {
                    CustomTextField(text: $viewModel.username, placeholder: "Username")
                }
                textFieldWithError(errorStates: [.passwordTooShort]) {
                    CustomSecureTextField(text: $viewModel.password, placeholder: "Password")
                }
                
                textFieldWithError(errorStates: [.passwordsDoNotMatch]) {
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
    }
    
    private func textFieldWithError(errorStates: [RegistrationState], textField: () -> some View) -> some View {
        VStack(spacing: 0) {
            textField()
            if errorStates.contains(viewModel.registrationState) {
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 14, height: 14)
                    

                    Text(viewModel.registrationState.errorMessage)
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
