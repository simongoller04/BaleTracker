//
//  BaleSettingsViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 10.03.24.
//

import Foundation
import Combine

@MainActor class BaleSettingsViewModel: ObservableObject {
    private var farmRepository = FarmRepositoryImpl.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var farms: [Farm]?
    
    init() {
        observeFarms()
    }
    
    private func observeFarms() {
        farmRepository.$farms
            .receive(on: DispatchQueue.main)
            .sink { [self] farms in
                self.farms = farms
            }
            .store(in: &cancellables)
    }
}
