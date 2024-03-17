//
//  MapViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation
import _MapKit_SwiftUI
import Combine

@MainActor class MapViewModel: ObservableObject {
    private var locationPermission = LocationPermission()
    private var baleRepository = BaleRepositoryImpl.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var mapStyle: MapStyle = .standard
    @Published var selectedCrop: Crop = .straw
    @Published var selectedBaleType: BaleType = .round
    @Published var selectedFarm: Farm?
    
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
                try await baleRepository.createBale(bale: BaleCreate(crop: selectedCrop,
                                                                     baleType: selectedBaleType,
                                                                     coordinate: Coordinate(latitude: coordinates.latitude.magnitude, longitude: coordinates.longitude.magnitude), 
                                                                     farm: selectedFarm?.id))
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
    
    func collectBale(id: String) {
        Task {
            do {
                try await baleRepository.collectBale(id: id)
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
}
