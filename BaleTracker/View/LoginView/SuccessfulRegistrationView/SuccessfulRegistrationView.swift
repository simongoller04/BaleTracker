//
//  SuccessfulRegistrationView.swift
//  BaleTracker
//
//  Created by Simon Goller on 19.12.23.
//

import SwiftUI

struct SuccessfulRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: Spacing.spacingL) {
            LogoHeader()
                .padding(.bottom, Spacing.spacing3XL)
            
            Text(R.string.localizable.successfullyCreated())
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Text(R.string.localizable.loginToContinue())
                .font(.title3)
                .multilineTextAlignment(.center)
            
            ActionButton(text: R.string.localizable.signIn()) {
                path = NavigationPath()
            }
        }
        .padding(Spacing.spacingM)
        .navigationBarBackButtonHidden()
    }
}

#Preview("Dark") {
    SuccessfulRegistrationView(path: .constant(NavigationPath()))
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    SuccessfulRegistrationView(path: .constant(NavigationPath()))
        .preferredColorScheme(.light)
}
