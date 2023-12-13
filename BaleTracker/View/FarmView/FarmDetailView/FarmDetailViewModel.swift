//
//  FarmDetailViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 06.11.23.
//

import Foundation

class FarmDetailViewModel: ObservableObject {
    @Published var farm: Farm
    
    init(farm: Farm) {
        self.farm = farm
    }
}
