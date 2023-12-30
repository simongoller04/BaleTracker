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
//    func login(email: String, password: String) async throws -> Token
//    func loginWithApple() async throws
}

final class AuthenticationRepositoryImpl: AuthenticationRepository, ObservableObject {
    static var shared = AuthenticationRepositoryImpl()
    var apiHandler = APIRequestHandler<AuthenticationApi>()
    
    @Published private(set) var loggedInfo: LoginInfo
    
    private init() {
        loggedInfo = .loggedOut
    }

    func register(user: UserRegisterDTO) async throws -> RegistrationState {
        let result = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .register(user: user), completion: { (result: Result<RegistrationState, Error>) in
                continuation.resume(with: result)
            })
        }
        return result
    }
    
//    func login(email: String, password: String) async throws -> Token {
//        // TODO: login
//    }
}

