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
    func deleteBale(id: String) async throws
    func getAllBales() async throws -> [Bale]?
    func getAllCreatedBales() async throws  -> [Bale]?
    func getAllCollectedBales() async throws  -> [Bale]?
    func getAllFromFarm(farmId: String) async throws -> [Bale]?
    func queryBales(query: BaleQuery) async throws -> [Bale]?
}

final class BaleRepositoryImpl: BaleRepository, ObservableObject {
    static var shared = BaleRepositoryImpl()
    internal var moya = CustomMoyaProvider<BaleApi>()
    
    @Published var bales: [Bale]?
    @Published var selectedCrop: CropFilter = .all
    @Published var selectedBaleType: BaleTypeFilter = .all
    @Published var selectedTimeSpan: TimeFilter = .weekly
    
    private var publishers = Set<AnyCancellable>()
    
    private var baleQuery: BaleQuery {
        let balequery = BaleQuery(crop: selectedCrop.rawValue,
                                  baleType: selectedBaleType.rawValue,
                                  createdBy: nil,
                                  creationTime: TimeSpan(with: selectedTimeSpan),
                                  collectedBy: nil,
                                  collectionTime: nil,
                                  coordinate: nil,
                                  farm: nil)
        return balequery
    }
    
    init() {
//        fetchBales()
        queryBales()
        observeFilters()
    }
    
    private func observeFilters() {
        $selectedCrop
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.queryBales()
            }
            .store(in: &publishers)

        $selectedBaleType
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.queryBales()
            }
            .store(in: &publishers)

        $selectedTimeSpan
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.queryBales()
            }
            .store(in: &publishers)
    }
    
    private func fetchBales(completionBlock: (([Bale]?) -> Void)? = nil) {
        _Concurrency.Task {
            do {
                "Fetching bales...".log()
                let bales = try await self.getAllBales()
                self.bales = bales
                completionBlock?(bales)
            } catch {
                completionBlock?(nil)
            }
        }
    }
    
    private func queryBales(completionBlock: (([Bale]?) -> Void)? = nil) {
        _Concurrency.Task {
            do {
                "Querying bales...".log()
                let bales = try await self.queryBales(query: baleQuery)
                self.bales = bales
                completionBlock?(bales)
            } catch {
                completionBlock?(nil)
            }
        }
    }
    
    // MARK: edit bales
    
    func createBale(bale: BaleCreate) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.createBale(bale: bale)) { result in
                continuation.resume(with: result)
                "Bale created: \n\(bale.toString())".log(.info)
                self.queryBales()
            }
        }
    }
    
    func collectBale(id: String) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.collectBale(id: id)) { result in
                continuation.resume(with: result)
                "Bale with id: \(id) collected".log(.info)
                self.queryBales()
            }
        }
    }
    
    func deleteBale(id: String) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.deleteBale(id: id)) { result in
                continuation.resume(with: result)
                "Bale with id: \(id) deleted".log(.info)
                self.queryBales()
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
