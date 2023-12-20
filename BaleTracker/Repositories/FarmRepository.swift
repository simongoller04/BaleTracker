//
//  FarmRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import Combine

protocol FarmRepository {
    func fetchFarms() async throws -> [Farm]
    func uploadFarm(farm: Farm) async throws -> Farm
    func getFarm(id: String) async throws -> Farm
}

final class FarmRepositoryImpl: Repository, FarmRepository, ObservableObject {
    static var shared = FarmRepositoryImpl()
    var apiHandler = APIRequestHandler<FarmApi>()
    
    @Published var farms: [Farm]?
    
    @discardableResult func fetchFarms() async throws -> [Farm] {
        let farms = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .getAllFarms) { (result: Result<[Farm], Error>) in
                continuation.resume(with: result)
            }
        }
        self.farms = farms
        return farms
    }
    
    func uploadFarm(farm: Farm) async throws -> Farm {
        let farm = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .createFarm(farm: farm), completion: { (result: Result<Farm, Error>) in
                continuation.resume(with: result)
            })
        }
        return farm
    }
    
    @discardableResult func getFarm(id: String) async throws -> Farm {
        let farm = try await withCheckedThrowingContinuation { continuation in
            apiHandler.request(target: .getFarm(id: id), completion: { (result: Result<Farm, Error>) in
                continuation.resume(with: result)
            })
        }
        return farm
    }
}
