//
//  CustomMoyaProvider.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Combine
import Foundation
import Moya

class CustomMoyaProvider<T>: MoyaProvider<T> where T: TargetType {
    override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
                  requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                  stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
        
    override func request(_ target: T, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Moya.Cancellable {
        if let authApi = target as? AuthenticationApi, case .refresh = authApi {
            return request(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: false, completion: completion)
        } else {
            return request(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: true, completion: completion)
        }
    }
    
    func requestWithResult<C: Codable>(_ target: T, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping (Result<C, Error>) -> ()) -> Moya.Cancellable {
        if let authApi = target as? AuthenticationApi, case .refresh = authApi {
            return requestWithCodable(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: false, completion: completion)
        } else {
            return requestWithCodable(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: true, completion: completion)
        }
    }
    
    // MARK: private functions
    
    @discardableResult
    private func request(_ target: T, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, shouldRetry: Bool, completion: @escaping Completion) -> Moya.Cancellable {
        super.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case let .success(response):
                if let _ = try? response.filter(statusCode: 401) {
                    AuthenticationRepositoryImpl.shared.refresh { [weak self] error in
                        if let error = error {
                            if let moyaError = error as? MoyaError {
                                completion(.failure(moyaError))
                            } else {
                                // TODO: This is not ideal yet, but we need a moya error here -> open for suggestions
                                completion(.failure(MoyaError.underlying(error, nil)))
                            }
                        } else {
                            if shouldRetry {
                                self?.request(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: false, completion: completion)
                            }
                        }
                    }
                } else if let _ = try? response.filter(statusCode: 200) {
                    completion(.success(response))
                } else {
                    do {
                        let error = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(MoyaError.underlying(error, nil)))
                    } catch {
                        completion(.failure(MoyaError.underlying(error, nil)))
                    }
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    private func requestWithCodable<C: Codable>(_ target: T, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, shouldRetry: Bool, completion: @escaping (Result<C, Error>) -> ()) -> Moya.Cancellable {
        super.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case let .success(response):
                if let _ = try? response.filter(statusCode: 401) {
                    AuthenticationRepositoryImpl.shared.refresh { [weak self] error in
                        if let error = error {
                            if let moyaError = error as? MoyaError {
                                completion(.failure(moyaError))
                            } else {
                                // TODO: This is not ideal yet, but we need a moya error here -> open for suggestions
                                completion(.failure(MoyaError.underlying(error, nil)))
                            }
                        } else {
                            if shouldRetry {
                                self?.requestWithCodable(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: false, completion: completion)
                            }
                        }
                    }
                } else if let _ = try? response.filter(statusCode: 200) {
                    do {
                        let results = try JSONDecoder().decode(C.self, from: response.data)
                        completion(.success(results))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    do {
                        let error = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(error))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
