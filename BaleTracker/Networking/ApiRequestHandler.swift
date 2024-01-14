//
//  ApiRequestHandler.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.10.23.
//

import Foundation
import Moya
import Combine

//class APIRequestHandler<API>: MoyaProvider<API> where API: TargetType {
class APIRequestHandler<API: TargetType> {
    let provider =  MoyaProvider<API>()
    
    func request<T: Codable>(target: API, completion: @escaping (Result<T, Error>) -> ()) {
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
    
    func request(target: API, completion: @escaping (Result<Response, MoyaError>) -> ()) {
        let result = provider.requestNormal(target, callbackQueue: nil, progress: nil, completion: completion)
    }
}

class CustomMoyaProvider<T>: MoyaProvider<T> where T: TargetType {
    private let decoder = JSONDecoder()
    
    override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping, requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping, stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub, callbackQueue: DispatchQueue? = nil, session: Moya.Session = MoyaProvider<Target>.defaultAlamofireSession(), plugins: [PluginType] = [], trackInflights: Bool = false) {
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601WithFractionalSeconds
        
        #if DEBUG
            var plugins = plugins
            plugins.append(NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)))
        #endif
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)
    }
}
