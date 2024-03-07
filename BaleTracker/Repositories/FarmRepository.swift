//
//  FarmRepository.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import Combine
import Moya

protocol FarmRepository: Repository {
    func createFarm(farm: FarmCreate) async throws -> Farm
    func updateFarm(id: String, farm: FarmUpdate) async throws -> Farm
    func getFarms() async throws -> [Farm]?
    func updateFarmPicture(id: String, imageData: Data, completionClosure: @escaping Completion)
    func deleteFarmPicture(id: String) async throws
}

final class FarmRepositoryImpl: FarmRepository, ObservableObject {
    static var shared = FarmRepositoryImpl()
    internal var moya = CustomMoyaProvider<FarmApi>()
    
    @Published var farms: [Farm]?
    
    private init() {
        fetchFarms()
    }
    
    func fetchFarms(completionBlock: (([Farm]?) -> Void)? = nil) {
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
    
    func createFarm(farm: FarmCreate) async throws -> Farm {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.createFarm(farm: farm)) { (result: Result<Farm, Error>) in
                continuation.resume(with: result)
                self.fetchFarms()
            }
        }
    }
    
    func updateFarm(id: String, farm: FarmUpdate) async throws -> Farm {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.updateFarm(id: id, farm: farm)) { (result: Result<Farm, Error>) in
                continuation.resume(with: result)
                self.fetchFarms()
            }
        }
    }
    
    func getFarms() async throws -> [Farm]? {
        return try await withCheckedThrowingContinuation { continuation in
            let _ = moya.requestWithResult(.getFarms) { (result: Result<[Farm]?, Error>) in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateFarmPicture(id: String, imageData: Data, completionClosure: @escaping Moya.Completion) {
        let _ = moya.request(.updateFarmPicture(id: id, image: imageData), callbackQueue: DispatchQueue.main, completion: completionClosure)
    }
    
    func deleteFarmPicture(id: String) async throws {
        let _ = try await withCheckedThrowingContinuation { continuation in
            let _ = moya.request(.deleteFarmPicture(id: id)) { result in
                continuation.resume(with: result)
            }
        }
    }
}
