//
//  RegistrationViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 15.12.23.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published var isEmailValid = true
    @Published var isUsernameValid = true
    @Published var isPasswordValid = true
    @Published var isRepeatPasswordValid = true
    
    @Published var isFormValid = false
    
    private var publishers = Set<AnyCancellable>()
    private var authenticationRepository = AuthenticationRepositoryImpl.shared
    
    init() {
        isSignupFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &publishers)
    }
    
    // MARK: input validation
    
    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
          $email
              .map { email in
                  if !email.isEmpty {
                      self.isEmailValid = email.isValidEmail
                      return email.isValidEmail
                  }
                  return true
              }
              .eraseToAnyPublisher()
      }
    
    var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map { name in
                if !name.isEmpty {
                    self.isUsernameValid = name.count >= 3
                    return self.isUsernameValid
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                if !password.isEmpty {
                    self.isPasswordValid = password.count >= 8
                    return self.isPasswordValid
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    
    var passwordMatchesPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatPassword)
            .map { password, repeated in
                if !password.isEmpty && !repeated.isEmpty {
                    self.isRepeatPasswordValid = password == repeated
                    return self.isRepeatPasswordValid
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            isUsernameValidPublisher,
            isEmailValidPublisher,
            isPasswordValidPublisher,
            passwordMatchesPublisher)
            .map { isNameValid, isEmailValid, isPasswordValid, passwordMatches in
              return isNameValid && isEmailValid && isPasswordValid && passwordMatches
            }
            .eraseToAnyPublisher()
    }
    
    func register() {
        Task {
            do {
                let result = try await authenticationRepository.register(user: UserRegisterDTO(email: email, username: username, password: password))
                print(result)
            } catch {
                print(error)
            }
        }
    }
}
