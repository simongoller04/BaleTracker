//
//  BaleDetailViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 11.02.24.
//

import Foundation

@MainActor class BaleDetailViewModel: ObservableObject {
    private var baleRepository = BaleRepositoryImpl.shared
    private var publicUserRepository = PublicUserRepositoryImpl.shared
    
    var bale: Bale
    
    @Published var collector: User?
    @Published var creator: User?
    
    init(bale: Bale) {
        self.bale = bale
        getUser(id: bale.createdBy, isCreator: true)
        if let collector = bale.collectedBy {
            getUser(id: collector, isCreator: false)
        }
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
    
    func getUser(id: String, isCreator: Bool) {
        Task {
            do {
                if isCreator {
                    self.creator = try await publicUserRepository.getUser(id: id)
                } else {
                    self.collector = try await publicUserRepository.getUser(id: id)
                }
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
}
