//
//  BaleRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Foundation
import Combine
import Moya

protocol BaleRepository: Repository {
    func createBale(bale: BaleCreate) async throws
    func collectBale(id: String) async throws
    func getAllBales() async throws -> [Bale]?
    func getAllCreatedBales() async throws  -> [Bale]?
    func getAllCollectedBales() async throws  -> [Bale]?
    func getAllFromFarm(farmId: String) async throws  -> [Bale]?
    func queryBales(query: BaleQuery) async throws -> [Bale]?
}

final class BaleRepositoryImpl: BaleRepository, ObservableObject {
    static var shared = BaleRepositoryImpl()
    internal var moya = CustomMoyaProvider<BaleApi>()
    
    @Published var bales: [Bale]?
    
    init() {
        fetchBales()
    }
    
    private func fetchBales(completionBlock: (([Bale]?) -> Void)? = nil) {
        _Concurrency.Task {
            do {
                "Fetching bales...".log()
                let bales = try await self.getAllBales()
                self.bales = bales
                if let bales = bales {
                    bales.count.description.log()
                }
                completionBlock?(bales)
            } catch {
                completionBlock?(nil)
            }
        }
    }
    
    private func queryBales() {
        
    }
    
    // MARK: edit bales
    
    func createBale(bale: BaleCreate) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.createBale(bale: bale)) { result in
                continuation.resume(with: result)
                self.fetchBales()
            }
        }
    }
    
    func collectBale(id: String) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.collectBale(id: id)) { result in
                continuation.resume(with: result)
                self.fetchBales()
            }
        }
    }
    
    // MARK: get bales
    
    func getAllBales() async throws -> [Bale]? {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getAllBales) { (result: Result<[Bale]?, Error>) in
                continuation.resume(with: result)
            }
        }
    }
    
    func getAllCreatedBales() async throws  -> [Bale]? {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getCreated) { (result: Result<[Bale]?, Error>) in
                continuation.resume(with: result)
            }
        }
    }
    
    func getAllCollectedBales() async throws  -> [Bale]? {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getCollected) { (result: Result<[Bale]?, Error>) in
                continuation.resume(with: result)
            }
        }
    }
    
    func getAllFromFarm(farmId: String) async throws  -> [Bale]? {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getAllFromFarm(farmId: farmId)) { (result: Result<[Bale]?, Error>) in
                continuation.resume(with: result)
            }
        }
    }
    
    func queryBales(query: BaleQuery) async throws -> [Bale]? {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.query(query: query)) { (result: Result<[Bale]?, Error>) in
                continuation.resume(with: result)
            }
        }
    }
}
