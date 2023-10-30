//
//  ApiRequestHandler.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Foundation
import Moya
import Combine

class APIRequestHandler<API: TargetType> {
    let provider =  MoyaProvider<API>()
    
    func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
//    func upload() {
//        provider.reque
//    }
}
