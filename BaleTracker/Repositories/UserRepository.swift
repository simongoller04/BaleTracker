//
//  UserRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation
import Combine
import Moya
import UIKit
import Kingfisher

protocol UserRepository: Repository {
    func fetchUser() async throws -> User
    func deleteUser() async throws -> UserDeletionResponse
    func updateProfilePicture(imageData: Data, completionClosure: @escaping Completion)
    func deleteProfilePicture() async throws
}

final class UserRepositoryImpl: UserRepository, ObservableObject {
    static var shared = UserRepositoryImpl()
    internal var moya = CustomMoyaProvider<UserApi>()
    private var cancellables = Set<AnyCancellable>()
    private let authRepo = AuthenticationRepositoryImpl.shared

    @Published private(set) var user: User?

    private init() {
        observeIsLoggedIn()
    }
    
    private func observeIsLoggedIn() {
        authRepo.$loggedInfo
            .receive(on: DispatchQueue.main, options: .none)
            .removeDuplicates()
            .sink { [weak self] status in
                switch status {
                case .loggedIn:
                    self?.fetchUser()
                default:
                    self?.user = nil
                }
            }
            .store(in: &cancellables)
    }
    
    
    func fetchUser(completionBlock: ((User?) -> Void)? = nil) {
        _Concurrency.Task {
            do {
                "Fetching user...".log()
                let user: User = try await self.fetchUser()
                self.user = user
                user.toString().log()
                completionBlock?(user)
            } catch {
                completionBlock?(nil)
            }
        }
    }

    @discardableResult internal func fetchUser() async throws -> User {
        let user = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getUser) { (result: Result<User, Error>) in
                continuation.resume(with: result)
            }
        }
        self.user = user
        return user
    }
    
    // TODO: does not work yet
    func deleteUser() async throws -> UserDeletionResponse {
        let result = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.deleteUser) { (result: Result<UserDeletionResponse, Error>) in
                continuation.resume(with: result)
            }
        }
        return result
    }
    
    func updateProfilePicture(imageData: Data, completionClosure: @escaping Completion) {
        let _ = moya.request(.updateProfilePicture(image: imageData), callbackQueue: DispatchQueue.main, completion: completionClosure)
    }
    
    func deleteProfilePicture() async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.deleteProfilePicture) { result in
                continuation.resume(with: result)
                self.fetchUser()
            }
        }
    }
}
