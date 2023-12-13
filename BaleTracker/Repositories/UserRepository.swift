//
//  UserRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation

protocol UserRepository {
    static var shared: UserRepositoryImpl { get }
    var apiHandler: APIRequestHandler<UserApi> { get }
    
    func fetchAllUsers() async throws -> [User]
    func createUser(user: User) async throws -> User
}

class UserRepositoryImpl: UserRepository, ObservableObject {
    static var shared = UserRepositoryImpl()
    var apiHandler = APIRequestHandler<UserApi>()
    
    @Published var users: [User]?
    
    @discardableResult func fetchAllUsers() async throws -> [User] {
        let users = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .getAllUser) { (result: Result<[User], Error>) in
                continuation.resume(with: result)
            }
        }
        self.users = users
        return users
    }
    
    func createUser(user: User) async throws -> User {
        let user = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .createUser(user: user), completion: { (result: Result<User, Error>) in
                continuation.resume(with: result)
            })
        }
        return user
    }
}
