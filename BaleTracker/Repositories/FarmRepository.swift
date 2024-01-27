//
//  FarmRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import Combine

protocol FarmRepository: Repository {
    func fetchFarms() async throws -> [Farm]
    func uploadFarm(farm: Farm) async throws -> Farm
    func getFarm(id: String) async throws -> Farm
}

final class FarmRepositoryImpl: FarmRepository, ObservableObject {    
    static var shared = FarmRepositoryImpl()
    internal var moya = CustomMoyaProvider<FarmApi>()
    
    @Published var farms: [Farm]?
    
    @discardableResult func fetchFarms() async throws -> [Farm] {
        let farms = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getAllFarms) { (result: Result<[Farm], Error>) in
                continuation.resume(with: result)
            }
        }
        self.farms = farms
        return farms
    }
    
    func uploadFarm(farm: Farm) async throws -> Farm {
        let farm = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.createFarm(farm: farm), completion: { (result: Result<Farm, Error>) in
                continuation.resume(with: result)
            })
        }
        return farm
    }
    
    @discardableResult func getFarm(id: String) async throws -> Farm {
        let farm = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getFarm(id: id), completion: { (result: Result<Farm, Error>) in
                continuation.resume(with: result)
            })
        }
        return farm
    }
}
