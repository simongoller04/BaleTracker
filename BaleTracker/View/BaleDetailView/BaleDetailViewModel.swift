//
//  BaleDetailViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 11.02.24.
//

import Foundation

@MainActor class BaleDetailViewModel: ObservableObject {
    private var baleRepository = BaleRepositoryImpl.shared
    
    func collectBale(id: String) {
        Task {
            do {
                try await baleRepository.collectBale(id: id)
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
    
    func deleteBale(id: String) {
        Task {
            do {
                try await baleRepository.deleteBale(id: id)
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
}
