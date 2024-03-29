//
//  LoginView.swift
//  BaleTracker
//
//  Created by Simon Goller on 13.12.23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 24) {
                LogoHeader()
                
                VStack(spacing: 0) {
                    TextFieldWithError(currentState: $viewModel.loginState, errorStates: [.invalidUsername]) {
                        CustomTextField(text: $viewModel.username, placeholder: R.string.localizable.username())
                    }
                    
                    VStack(spacing: Spacing.spacingXS) {
                        CustomSecureTextField(text: $viewModel.password, placeholder: R.string.localizable.password())

                        HStack {
                            TextFieldWithError(currentState: $viewModel.loginState, errorStates: [.invalidPassword]) {
                                EmptyView()
                            }
                            Spacer()
                            Button(R.string.localizable.forgotPassword()) {
                                // TODO: resset password
                            }
                            .font(.footnote)
                        }
                    }
                }
                
                ActionButton(isLoading: viewModel.isLoginIn, text: R.string.localizable.signIn()) {
                    viewModel.login()
                }
                
                divider
                
                CustomSocialButton(isLoading: false,
                                   image: Image(systemName: "apple.logo"),
                                   imageColor: Color(uiColor: UIColor.systemBackground),
                                   text: R.string.localizable.continueWithApple(),
                                   textColor: Color(uiColor: UIColor.systemBackground),
                                   backgroundColor: Color(uiColor: UIColor.label)) {
                    // TODO: implement login with apple
                }
                
                CustomSocialButton(isLoading: false,
                                   image: Image(R.image.google),
                                   text: R.string.localizable.continueWithGoogle(),
                                   textColor: Color(uiColor: UIColor.systemBackground),
                                   backgroundColor: Color(uiColor: UIColor.label)) {
                    // TODO: implement login with google
                }
                
                Spacer()
                
                signUp
            }
            .padding(Spacing.spacingM)
            .navigationDestination(for: RegistrationFLowNavigationItem.self) { item in
                item.destination(path: $path)
            }
            .navigationTitle(RegistrationFLowNavigationItem.loginView.navigationTitle)
            .toolbar(.hidden, for: .navigationBar)
            .textInputAutocapitalization(.never)
        }
    }
    
    private var signUp: some View {
        HStack(spacing: Spacing.spacingL) {
            Text(R.string.localizable.noAccount())
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            NavigationLink(value: RegistrationFLowNavigationItem.registrationView) {
                Text(R.string.localizable.signUp())
                    .font(.footnote)
            }
            .foregroundStyle(Color.accentColor)
        }
    }
    
    private var divider: some View {
        Divider()
            .overlay {
                Text(R.string.localizable.or())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, Spacing.spacingS)
                    .background(Color(uiColor: UIColor.systemBackground))
            }
    }
}

#Preview("Light") {
    LoginView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    LoginView()
        .preferredColorScheme(.dark)
}
