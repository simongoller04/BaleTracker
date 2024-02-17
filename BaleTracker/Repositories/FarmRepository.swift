//
//  FarmRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import Combine

protocol FarmRepository: Repository {
    func createFarm(farm: FarmCreate) async throws
    func getFarms() async throws -> [Farm]
}

final class FarmRepositoryImpl: FarmRepository, ObservableObject {
    static var shared = FarmRepositoryImpl()
    internal var moya = CustomMoyaProvider<FarmApi>()
    
    @Published var farms: [Farm]?
    
    private init() {
        fetchFarms()
    }
    
    private func fetchFarms(completionBlock: (([Farm]?) -> Void)? = nil) {
        _Concurrency.Task {
            do {
                "Fetching farms...".log()
                let farms = try await self.getFarms()
                self.farms = farms
                completionBlock?(farms)
            } catch {
                completionBlock?(nil)
            }
        }
    }
    
    func createFarm(farm: FarmCreate) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.createFarm(farm: farm)) { result in
                continuation.resume(with: result)
                self.fetchFarms()
            }
        }
    }
    
    func getFarms() async throws -> [Farm] {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getFarms) { (result: Result<[Farm], Error>) in
                continuation.resume(with: result)
            }
        }
    }
}
