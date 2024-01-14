//
//  UserRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation
import Combine
import Moya

protocol UserRepository: Repository {
    func fetchUser() async throws -> User
    func deleteUser() async throws -> UserDeletionResponse
    func updateProfilePicture(imageData: Data, completionClosure: @escaping Completion)
    func deleteProfilePicture() async throws
}

final class UserRepositoryImpl: UserRepository, ObservableObject {
    static var shared = UserRepositoryImpl()
    var apiHandler = APIRequestHandler<UserApi>()
    
    private var moya = MoyaProvider<UserApi>()
        
    private var cancellables = Set<AnyCancellable>()

    private let authRepo = AuthenticationRepositoryImpl.shared

    @Published private(set) var user: User?
    @Published var users: [User]?

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
            apiHandler.request(target: .getUser) { (result: Result<User, Error>) in
                continuation.resume(with: result)
            }
        }
        self.user = user
        return user
    }
    
    // TODO: does not work yet
    func deleteUser() async throws -> UserDeletionResponse {
        let result = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .deleteUser, completion: { (result: Result<UserDeletionResponse, Error>) in
                continuation.resume(with: result)
            })
        }
        return result
    }
    
    func updateProfilePicture(imageData: Data, completionClosure: @escaping Completion) {
//        apiHandler.request(target: .updateProfilePicture(image: imageData), completion: completionClosure)
        moya.request(.updateProfilePicture(image: imageData), callbackQueue: DispatchQueue.main, completion: completionClosure)
    }
    
    func deleteProfilePicture() async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            moya.request(.deleteProfilePicture) { result in
                continuation.resume(with: result)
                self.fetchUser()
            }
        }
    }
}

enum UserDeletionResponse: String, Codable {
    case deleted = "DELETED"
    case notDeleted = "NOT_DELETED"
}
