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
}

//
//class CustomMoyaProvider<T>: MoyaProvider<T> where T: TargetType {
//    private let decoder = JSONDecoder()
//
//    override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping, requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping, stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub, callbackQueue: DispatchQueue? = nil, session: Moya.Session = MoyaProvider<Target>.defaultAlamofireSession(), plugins: [PluginType] = [], trackInflights: Bool = false) {
//        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
//
//        #if DEBUG
//            var plugins = plugins
//            plugins.append(NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)))
//        #endif
//
//        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)
//    }
//
//    func requestVoidPublisher(_ target: T, callbackQueue: DispatchQueue? = nil) -> AnyPublisher<Response, Error> {
//        let publisher = super.requestPublisher(target, callbackQueue: callbackQueue)
//        return publisher
//            .tryMap { [weak self] response in
//                guard let self else {
//                    throw CustomError.generic(message: "Weak self nil")
//                }
//
//                try self.statusCodeControlOf(response: response)
//
//                return response
//            }
//            .eraseToAnyPublisher()
//    }
//
//    func requestPublisher<D: Decodable>(_ target: T, callbackQueue: DispatchQueue? = nil) -> AnyPublisher<D, Error> {
//        let publisher = super.requestPublisher(target, callbackQueue: callbackQueue)
//
//        return publisher
//            .tryMap { [weak self] response -> D in
//
//                guard let self else {
//                    throw CustomError.generic(message: "Weak self nil")
//                }
//
//                let decodedResponse: D?
//
//                if let response = try? response.filterSuccessfulStatusCodes() {
//                    do {
//                        // perform JSON mapping of expected response type
//                        decodedResponse = try self.decoder.decode(D.self, from: response.data)
//                    } catch {
//                        decodedResponse = nil
//
//                        if let _ = error as? DecodingError {
//                            // TODO: e.g. report error to error reporting API
//                        }
//
//                        if let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: response.data) {
//                            throw CustomError.errorResponse(errorResponse: errorResponse)
//                        } else {
//                            throw MoyaError.jsonMapping(response)
//                        }
//                    }
//                } else {
//                    decodedResponse = nil
//                }
//
//                if let decodedResponse {
//                    return decodedResponse
//                } else {
//                    // try JSON mapping of the error to our error class
//                    if let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: response.data) {
//                        throw CustomError.errorResponse(errorResponse: errorResponse)
//                    } else {
//                        "Status code error: \(response.statusCode)".log()
//                        throw MoyaError.statusCode(response)
//                    }
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//
//    private func statusCodeControlOf(response: Response) throws {
//        if let _ = try? response.filterSuccessfulStatusCodes() {
//            return
//        } else {
//            // try JSON mapping of the error to our error class
//            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: response.data) {
//                throw CustomError.errorResponse(errorResponse: errorResponse)
//            } else {
//                "Status code error: \(response.statusCode)".log()
//                throw MoyaError.statusCode(response)
//            }
//        }
//    }
//
//    @discardableResult
//    private func request(_ target: T, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, shouldRetry: Bool, completion: @escaping Completion) -> Moya.Cancellable {
//        super.request(target, callbackQueue: callbackQueue, progress: progress) { result in
//            switch result {
//            case let .success(response):
//                if let _ = try? response.filter(statusCode: 401), shouldRetry { // if status is 401, we need to refresh access token
//                    AuthenticationRepository.shared.refreshTokenSync { [weak self] error in
//                        if let error = error {
//                            if let moyaError = error as? MoyaError {
//                                completion(.failure(moyaError))
//                            } else {
//                                // TODO: This is not ideal yet, but we need a moya error here -> open for suggestions
//                                completion(.failure(MoyaError.underlying(error, nil)))
//                            }
//                        } else {
//                            // re-try the request
//                            // make sure to set shouldRetry to false this time to avoid endless retry loop
//                            // additionally, if shouldRetry is not set to false requests can get stuck in AuthenticationRepository refreshTokenSync as only one refresh request can be active at a time
//                            self?.request(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: false, completion: completion)
//                        }
//                    }
//                } else {
//                    completion(.success(response))
//                }
//            case let .failure(moyaError):
//                completion(.failure(moyaError))
//            }
//        }
//    }
//
//    override func request(_ target: T, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Moya.Cancellable {
//        if let authApi = target as? AuthenticationApi, case .refreshToken = authApi {
//            return request(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: false, completion: completion)
//        } else {
//            return request(target, callbackQueue: callbackQueue, progress: progress, shouldRetry: true, completion: completion)
//        }
//    }
//}
