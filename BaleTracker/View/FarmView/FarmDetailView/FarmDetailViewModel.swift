//
//  FarmDetailViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 06.11.23.
//

import Foundation
import UIKit
import Combine
import MapKit

class FarmDetailViewModel: SelectFarmLocationViewModel {
    private let publicUserRepository = PublicUserRepositoryImpl.shared
    private let userRepository = UserRepositoryImpl.shared
    private let farmRepository = FarmRepositoryImpl.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var farm: Farm
    @Published var selectedImage: UIImage?
    @Published var uploadProgress = 0.0
    @Published var isUploading = false
    @Published var deleteImage = false
    
    @Published var region: MKCoordinateRegion?
    @Published var oldRegion: MKCoordinateRegion?

    @Published var members: [User]?
    @Published var user: User?
    
    // updated values
    @Published var newName: String
    @Published var newDescription: String
    @Published var newCoordinate: Coordinate?
    @Published var newMembers: [String]
    
    init(farm: Farm) {
        self.farm = farm
        
        region = farm.coordinate?.toMKCoordinateRegion()
        oldRegion = farm.coordinate?.toMKCoordinateRegion()
        
        newName = farm.name
        if let description = farm.description {
            newDescription = description
        } else {
            newDescription = ""
        }
        newCoordinate = farm.coordinate
        newMembers = farm.members
        
        observeUser()
        observeRegion()
        fetchMembers(ids: farm.members)
    }
    
    private var farmUpdate: FarmUpdate {
        if newDescription == "" {
            return FarmUpdate(name: newName, description: nil, coordinate: newCoordinate, members: newMembers)
        } else {
            return FarmUpdate(name: newName, description: newDescription, coordinate: newCoordinate, members: newMembers)
        }
    }
    
    // MARK: private functions
    
    private func observeUser() {
        userRepository.$user
            .receive(on: DispatchQueue.main, options: .none)
            .sink { [self] user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    private func observeRegion() {
        $region
            .receive(on: DispatchQueue.main)
            .sink { region in
                self.newCoordinate = region?.center.toCoordinate()
            }
            .store(in: &cancellables)
    }
    
    private func fetchMembers(ids: [String]) {
        Task {
            do {
                self.members = try await publicUserRepository.getUsers(ids: ids)
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
    
    private func updateFarmPicture(image: UIImage) {
        isUploading = true
        if let image = image.jpegData(compressionQuality: 0.5) {
            farmRepository.updateFarmPicture(id: farm.id, imageData: image) { [self] result in
                switch result {
                case .success:
                    farmRepository.fetchFarms()
                    isUploading = false
                    "Image uploaded sucessfully".log(.info)
                case .failure:
                    isUploading = false
                    "Failed to upload image".log(.error)
                }
            }
        }
    }
    
    private func deleteFarmPicture() {
        Task {
            do {
                try await farmRepository.deleteFarmPicture(id: farm.id)
                selectedImage = nil
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
    
    // MARK: public functions

    func cancel() {
        // When you cancel the editing process, the values are reset to the previous ones
        newCoordinate = farm.coordinate
        region = oldRegion
        
        newName = farm.name
        if let description = farm.description {
            newDescription = description
        } else {
            newDescription = ""
        }
        newCoordinate = farm.coordinate
        newMembers = farm.members
        deleteImage = false
    }
    
    func updateFarm() {
        Task  {
            do {
                isUploading = true
                self.farm = try await farmRepository.updateFarm(id: farm.id, farm: farmUpdate)
                if let image = selectedImage {
                    updateFarmPicture(image: image)
                } else if deleteImage {
                    deleteFarmPicture()
                }
                isUploading = false
            } catch {
                isUploading = false
                error.localizedDescription.log(.error)
            }
        }
    }
}
