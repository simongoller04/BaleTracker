//
//  BaleRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Foundation
import Combine
import Moya

protocol BaleRepository {
    static var shared: BaleRepositoryImpl { get }
    var apiHandler: APIRequestHandler<BaleApi> { get }
    
    func createBale(bale: BaleCreate) async throws
    func collectBale(id: String) async throws
    func getAllBales() async throws -> [Bale]?
}

class BaleRepositoryImpl: BaleRepository, ObservableObject {
    static var shared = BaleRepositoryImpl()
    internal var apiHandler = APIRequestHandler<BaleApi>()
    private var moya = MoyaProvider<BaleApi>()
    
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
    
    func createBale(bale: BaleCreate) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            moya.request(.createBale(bale: bale)) { result in
                continuation.resume(with: result)
                self.fetchBales()
            }
        }
    }
    
    func collectBale(id: String) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            moya.request(.collectBale(id: id)) { result in
                continuation.resume(with: result)
                self.fetchBales()
            }
        }
    }
    
    func getAllBales() async throws -> [Bale]? {
        return try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .getAllBales, completion: { (result: Result<[Bale]?, Error>) in
                continuation.resume(with: result)
            })
        }
    }
}
