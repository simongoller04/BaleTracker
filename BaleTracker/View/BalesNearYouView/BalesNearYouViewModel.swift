//
//  BalesNearYouViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.12.23.
//

import Foundation
import Combine


@MainActor class BalesNearYouViewModel: ObservableObject {
    @Published var bales: [Bale]?
    
    var baleRepository = BaleRepositoryImpl.shared
    private var publishers = Set<AnyCancellable>()
    
    init() {
        observeBales()
    }
    
    private func observeBales() {
        baleRepository.$bales
            .receive(on: DispatchQueue.main)
            .sink { bales in
                self.bales = bales
            }
            .store(in: &publishers)
    }
    
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
