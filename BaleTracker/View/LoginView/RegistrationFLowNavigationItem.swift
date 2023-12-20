//
//  RegistrationFLowNavigationItem.swift
//  BaleTracker
//
//  Created by Simon Goller on 20.12.23.
//

import Foundation
import SwiftUI

enum RegistrationFLowNavigationItem: Codable, Hashable {
    case loginView
    case registrationView
    case successfulRegistrationView
    
    @ViewBuilder
    func destination(path: Binding<NavigationPath>) ->  some View {
        switch self {
        case .loginView:
            LoginView()
        case .registrationView:
            RegistrationView(path: path)
        case .successfulRegistrationView:
            SuccessfulRegistrationView(path: path)
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .loginView:
            return R.string.localizable.signIn()
        case .registrationView, .successfulRegistrationView:
            return ""
        }
    }
}
