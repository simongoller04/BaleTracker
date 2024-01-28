//
//  LoginViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 13.12.23.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoginIn = false
    @Published var loginState: ErrorResponse = .none
    
    private var authenticationRepository = AuthenticationRepositoryImpl.shared

    func login() {
        isLoginIn = true
        Task {
            do {
                try await authenticationRepository.login(loginDTO: UserLoginDTO(username: username, password: password))
                isLoginIn = false
            } catch {
                loginState = error as! ErrorResponse
                isLoginIn = false
            }
        }
    }
}
