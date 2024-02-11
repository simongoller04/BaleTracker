//
//  BalesNearYouViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.12.23.
//

import Foundation
import Combine


@MainActor class BalesNearYouViewModel: ObservableObject {
    @Published var selectedCrop: CropFilter = .all
    @Published var selectedBaleType: BaleTypeFilter = .all
    @Published var selectedTimeSpan: TimeFilter = .weekly

    @Published var bales: [Bale]?
    
    private var baleRepository = BaleRepositoryImpl.shared
    private var publishers = Set<AnyCancellable>()
    
    private var baleQuery: BaleQuery {
        let creationTime = TimeSpan(with: selectedTimeSpan)
        let balequery = BaleQuery(crop: selectedCrop.rawValue,
                                  baleType: selectedBaleType.rawValue,
                                  createdBy: nil,
                                  creationTime: creationTime,
                                  collectedBy: nil,
                                  collectionTime: nil,
                                  coordinate: nil,
                                  farm: nil)
        return balequery
    }
    
    init() {
        requestQuery()
        observeFilters()
    }
    
    private func observeFilters() {
        $selectedCrop
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.requestQuery()
            }
            .store(in: &publishers)
        
        $selectedBaleType
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.requestQuery()
            }
            .store(in: &publishers)
        
        $selectedTimeSpan
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.requestQuery()
            }
            .store(in: &publishers)
    }
    
    func requestQuery() {
        Task {
            do {
                bales = try await baleRepository.queryBales(query: baleQuery)
            } catch {
                error.localizedDescription.log(.error)
            }
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
        requestQuery()
    }
}
