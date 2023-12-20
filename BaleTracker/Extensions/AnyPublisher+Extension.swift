//
//  AnyPublisher+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 16.12.23.
//

import Combine
import Foundation

extension AnyPublisher {
    /// Turns the Combine API publisher into async / await throws
    @discardableResult
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(throwing: CustomError.generic(message: "Finished without value"))
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(with: .success(value))
                }
        }
    }
}
