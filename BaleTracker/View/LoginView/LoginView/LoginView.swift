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
                    CustomTextField(text: $viewModel.email, placeholder: R.string.localizable.email())
                    
                    VStack(spacing: Spacing.spacingXS) {
                        CustomSecureTextField(text: $viewModel.password, placeholder: R.string.localizable.password())
                        Button(R.string.localizable.forgotPassword()) {
                            // TODO: resset password
                        }
                        .font(.footnote)
                        .fullWidth(.trailing)
                    }
                }
                
                ActionButton(text: R.string.localizable.signIn()) {
                    // TODO: login
                }
                
                divider
                
                CustomSocialButton(isLoading: false,
                                   image: Image(systemName: "apple.logo"),
                                   imageColor: Color(uiColor: UIColor.systemBackground),
                                   text: R.string.localizable.continueWithApple(),
                                   textColor: Color(uiColor: UIColor.systemBackground),
                                   backgroundColor: Color(uiColor: UIColor.label)) {
                    // login
                }
                
                CustomSocialButton(isLoading: false,
                                   image: Image(R.image.google),
                                   text: R.string.localizable.continueWithGoogle(),
                                   textColor: Color(uiColor: UIColor.systemBackground),
                                   backgroundColor: Color(uiColor: UIColor.label)) {
                    // login
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
