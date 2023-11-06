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
    
    func fetchBales()
    func uploadBale(bale: Bale, completion: @escaping (Result<Bale, Error>) -> ())
}

class BaleRepositoryImpl: BaleRepository, ObservableObject {
    static var shared = BaleRepositoryImpl()
    var apiHandler = APIRequestHandler<BaleApi>()
    
    @Published var bales: [Bale]?
    
//    func fetchBales(completion: @escaping (Result<[Bale], Error>) -> ()) {
//        apiHandler.request(target: .getAllBales, completion: completion)
//    }
    
    func fetchBales() {
        apiHandler.request(target: BaleApi.getAllBales, completion: { (result: Result<[Bale], Error>) in
            switch result {
            case .success(let receivedBales):
                self.bales = receivedBales
            case .failure(let error):
                print("Failed to fetch bales: \(error)")
            }
        })
    }
    
    func uploadBale(bale: Bale, completion: @escaping (Result<Bale, Error>) -> ()) {
        apiHandler.request(target: .uploadBale(bale: bale), completion: completion)
    }
}
