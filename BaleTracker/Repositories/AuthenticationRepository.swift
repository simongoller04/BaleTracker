//
//  AuthenticationRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 16.12.23.
//

import Foundation
import Moya
import Combine

enum LoginInfo: Equatable {
    case loggedOut
    case loggedIn
}

protocol AuthenticationRepository: Repository {
    func register(user: UserRegisterDTO) async throws -> ErrorResponse
    func login(loginDTO: UserLoginDTO) async throws
    func refresh(completion: @escaping (Error?) -> Void)
}

final class AuthenticationRepositoryImpl: AuthenticationRepository, ObservableObject {
    static var shared = AuthenticationRepositoryImpl()
    internal var moya = CustomMoyaProvider<AuthenticationApi>()
    private var cancellable: Set<AnyCancellable> = []

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
    
    func register(user: UserRegisterDTO) async throws -> ErrorResponse {
        let result = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.register(user: user), completion: { (result: Result<ErrorResponse, Error>) in
                continuation.resume(with: result)
            })
        }
        return result
    }
    
    func login(loginDTO: UserLoginDTO) async throws {
        self.token = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.login(loginDTO: loginDTO), completion: { (result: Result<Token?, Error>) in
                continuation.resume(with: result)
            })
        }
    }

    func refresh(completion: @escaping (Error?) -> Void) {
        if let token = self.token?.refreshToken, !token.isEmpty  {
            
            let _ = moya.requestWithResult(.refresh(token: RefreshToken(refreshToken: token))) { (result: Result<Token, Error>) in
                result.publisher
                    .sink { compleded in
                        switch compleded {
                        case .finished:
                            completion(nil)
                        case let .failure(error):
                            "Failed to refresh access token using refresh token".log(.error)
                            completion(error)
                            error.localizedDescription.log(.error)
                            LogoutUseCase().execute()
                        }
                    } receiveValue: { newToken in
                        self.token = newToken
                        "Successfully refreshed access token using refresh token".log()
                    }.store(in: &self.cancellable)
            }
        }
    }
}

