//
//  LoginViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 13.12.23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}
