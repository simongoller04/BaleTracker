//
//  AuthenticationRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 16.12.23.
//

import Foundation
import Moya

enum LoginInfo: Equatable {
    case loggedOut
    case loggedIn
}

protocol AuthenticationRepository: Repository {
    func register(user: UserRegisterDTO) async throws -> RegistrationState
    func login(loginDTO: UserLoginDTO) async throws
}

final class AuthenticationRepositoryImpl: AuthenticationRepository, ObservableObject {
    static var shared = AuthenticationRepositoryImpl()
    var apiHandler = APIRequestHandler<AuthenticationApi>()
    
    private init() {
        internalToken = KeyChain.load(key: .token)
        setLoggedInfo()
    }

    /// Enum observable indicating the current logged in state of the user
    @Published private(set) var loggedInfo: LoginInfo?

    private var internalToken: Token? {
        didSet {
            DispatchQueue.main.async {
                self.setLoggedInfo()
            }
        }
    }

    private func setLoggedInfo() {
        if let _ = internalToken {
            loggedInfo = .loggedIn
        } else {
            loggedInfo = .loggedOut
        }
    }

    /// The currently stored access & refresh token
    private(set) var token: Token? {
        get {
            if let token = internalToken {
                return token
            } else {
                let token: Token? = KeyChain.load(key: .token)
                internalToken = token
                return token
            }
        }
        set {
            internalToken = newValue
            if let token = newValue {
                KeyChain.save(key: .token, encodable: token)
            } else {
                KeyChain.delete(key: .token)
            }
        }
    }
    
    func clear() {
        token = nil
    }
    
    // MARK: API calls
    
    func register(user: UserRegisterDTO) async throws -> RegistrationState {
        let result = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .register(user: user), completion: { (result: Result<RegistrationState, Error>) in
                continuation.resume(with: result)
            })
        }
        return result
    }
    
    func login(loginDTO: UserLoginDTO) async throws {
        self.token = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .login(loginDTO: loginDTO), completion: { (result: Result<Token?, Error>) in
                continuation.resume(with: result)
            })
        }
        print(self.token)
    }
}

