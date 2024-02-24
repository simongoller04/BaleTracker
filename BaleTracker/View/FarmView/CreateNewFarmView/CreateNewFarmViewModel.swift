//
//  CreateNewFarmViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 07.11.23.
//

import Foundation
import UIKit
import Combine
import _MapKit_SwiftUI
import CoreLocation

@MainActor class CreateNewFarmViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var selectedImage: UIImage?
    @Published var members: [User]?
    @Published var region: MKCoordinateRegion?
    
    @Published var isFormValid = false
    @Published var isUploading = false
    
    private var farmRepository = FarmRepositoryImpl.shared
    private var subscriptions = Set<AnyCancellable>()
    
    private var farmCreate: FarmCreate {
        let membersString = members?.map({ $0.id })
        if description.isEmpty {
            return FarmCreate(name: name, description: nil, coordinate: region?.center.toCoordinate(), members: membersString)
        } else {
            return FarmCreate(name: name, description: description, coordinate: region?.center.toCoordinate(), members: membersString)
        }
    }

    init() {
        isNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &subscriptions)
    }
    
    // MARK: input validation
    
    var isNameValidPublisher: AnyPublisher<Bool, Never> {
        $name
            .map { name in
               let namePredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Za-z0-9 .-]{2,20}")
               return namePredicate.evaluate(with: name)
            }
            .eraseToAnyPublisher()
    }
    
    
    func createFarm() {
        Task  {
            do {
                isUploading = true
                let newFarm = try await farmRepository.createFarm(farm: farmCreate)
                if selectedImage != nil {
                    updateFarmPicture(id: newFarm.id)
                }
                isUploading = false
            } catch {
                isUploading = false
                error.localizedDescription.log(.error)
            }
        }
    }
    
    private func updateFarmPicture(id: String) {
        isUploading = true
        if let image = selectedImage?.jpegData(compressionQuality: 0.5) {
            farmRepository.updateFarmPicture(id: id, imageData: image) { [self] result in
                switch result {
                case .success:
                    farmRepository.fetchFarms()
                    self.selectedImage = nil
                    isUploading = false
                    "Image uploaded sucessfully".log(.info)
                case .failure:
                    isUploading = false
                    "Failed to upload image".log(.error)
                }
            }
        }
    }
}
