//
//  RegistrationViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 15.12.23.
//

import Foundation
import Combine

@MainActor
class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published var isFormValid = false
    @Published var registrationState: ErrorResponse = .none 
    
    private var publishers = Set<AnyCancellable>()
    private var authenticationRepository = AuthenticationRepositoryImpl.shared
    
    init() {
        isSignupFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &publishers)
    }
    
    // MARK: input validation
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
          $email
              .map { email in
                  if !email.isEmpty {
                      if !email.isValidEmail {
                          self.registrationState = .emailInvalid
                      } else {
                          self.registrationState = .none
                      }
                      return email.isValidEmail
                  }
                  return false
              }
              .eraseToAnyPublisher()
      }
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map { name in
                if !name.isEmpty {
                    if name.count >= 3 {
                        self.registrationState = .none
                        return true
                    } else {
                        self.registrationState = .usernameTooShort
                        return false
                    }
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                if !password.isEmpty {
                    if password.count >= 8 {
                        self.registrationState = .none
                        return true
                    } else {
                        self.registrationState = .passwordTooShort
                        return false
                    }
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    
    private var passwordMatchesPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatPassword)
            .map { password, repeated in
                if !password.isEmpty && !repeated.isEmpty {
                    if password == repeated {
                        self.registrationState = .none
                        return true
                    } else {
                        self.registrationState = .passwordsDoNotMatch
                        return false
                    }
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    private var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
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
    
    // MARK: Registration
    
    func register(completion: @escaping () -> Void) {
        Task {
            do {
               registrationState = try await authenticationRepository.register(user: UserRegisterDTO(email: email, username: username, password: password))
                completion()
            } catch {
                registrationState = error as! ErrorResponse
            }
        }
    }
}
