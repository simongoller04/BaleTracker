//
//  MapViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import _MapKit_SwiftUI
import Combine

@MainActor
class MapViewModel: ObservableObject {
    private var locationPermission = LocationPermission()
    private var baleRepository = BaleRepositoryImpl.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var mapStyle: MapStyle = .standard
    @Published var selectedCrop: Crop = .straw
    @Published var selectedBaleType: BaleType = .round
    @Published var bales: [Bale]?
    
    init() {
        observeBales()
    }
    
    private func observeBales() {
        baleRepository.$bales
            .receive(on: DispatchQueue.main)
            .sink { [self] bales in
                self.bales = bales
            }
            .store(in: &cancellables)
    }
    
    func createBale() {
        Task {
            do {
                guard let coordinates = locationPermission.coordinates else { return }
                coordinates.latitude.description.log(.info)
                coordinates.longitude.description.log(.info)
                try await baleRepository.createBale(bale: BaleCreate(crop: selectedCrop,
                                                           baleType: selectedBaleType,
                                                           longitude: coordinates.longitude.magnitude,
                                                           latitude: coordinates.latitude.magnitude))
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
    }
    
    func getBales() {
        Task {
            do {
                self.bales = try await baleRepository.getAllBales()
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
}
