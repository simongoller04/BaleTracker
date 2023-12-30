//
//  LoginViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 13.12.23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    private var authenticationRepository = AuthenticationRepositoryImpl.shared

    func login() {
        Task {
            do {
                try await authenticationRepository.login(loginDTO: UserLoginDTO(username: username, password: password))
            } catch {
                print(error)
            }
        }
    }
}
