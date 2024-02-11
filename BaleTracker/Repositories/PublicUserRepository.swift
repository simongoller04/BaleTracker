//
//  PublicUserRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 11.02.24.
//

import Foundation
import Combine

protocol PublicUserRepository: Repository {
    func getUser(id: String) async throws -> User
}

final class PublicUserRepositoryImpl: PublicUserRepository {
    static var shared = PublicUserRepositoryImpl()
    internal var moya = CustomMoyaProvider<PublicUserApi>()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func getUser(id: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getUser(id: id)) { (result: Result<User, Error>) in
                continuation.resume(with: result)
            }
        }
    }
}
