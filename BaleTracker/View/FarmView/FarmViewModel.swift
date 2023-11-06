//
//  FarmViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import Combine

class FarmViewModel: ObservableObject {
    @Published var searchableText: String = ""
    @Published var filteredFarms: [Farm]?
    
    private var farms: [Farm]?
    
    private var subscriptions = Set<AnyCancellable>()
    private let farmRepository = FarmRepositoryImpl.shared
    
    init() {
        fetchFarms()
        addSubscribtion()
    }
    
    // MARK: - private functions
    
    private func addSubscribtion() {
        farmRepository.$farms
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] result in
                result.map { farms in
                    filteredFarms = farms
                    self.farms = farms
                }
            }.store(in: &subscriptions)
        
        $searchableText
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                filterFarms()
            }.store(in: &subscriptions)
    }
    
    private func filterFarms() {
        if let farms = farms {
            if searchableText.isEmpty {
                filteredFarms = farms
            } else {
                filteredFarms = farms.filter {
                    $0.name.localizedCaseInsensitiveContains(searchableText)
                }
            }
        }
    }
    
    // MARK: - functions
    
    func fetchFarms() {
        Task {
            try? await farms = farmRepository.fetchFarms()
            filteredFarms = farms
        }
    }
}
