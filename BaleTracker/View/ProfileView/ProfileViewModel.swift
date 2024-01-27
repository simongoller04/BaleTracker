//
//  ProfileViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 30.12.23.
//

import Foundation
import Combine
import UIKit
import Kingfisher

@MainActor
class ProfileViewModel: ObservableObject {
    private let logoutUseCase = LogoutUseCase()
    private let userRepository = UserRepositoryImpl.shared
    private let mediaRepository = MediaRepository()
    
    private var cancellables = Set<AnyCancellable>()

    @Published var user: User?
    @Published var selectedImage: UIImage? = nil
    @Published var profilePicture: UIImage? = nil
    @Published var uploadProgress = 0.0
    @Published var isUploading = false
    
    init() {
        observeUser()
        observeSelectedImage()
    }
    
    private func observeUser() {
        userRepository.$user
            .receive(on: DispatchQueue.main, options: .none)
            .sink { [self] user in
                self.user = user
                self.getCurrentProfilePicture()
            }
            .store(in: &cancellables)
    }
    
    private func observeSelectedImage() {
        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { image in
                if let image = image {
                    self.updateProfilePicture(selectedImage: image)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateProfilePicture(selectedImage: UIImage) {
        isUploading = true
        guard let image = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        userRepository.updateProfilePicture(imageData: image) { [self] result in
            switch result {
            case .success:
                userRepository.fetchUser()
                self.selectedImage = nil
                isUploading = false
                "Image uploaded sucessfully".log(.info)
            case .failure:
                isUploading = false
                "Failed to upload image".log(.error)
            }
        }
    }
    
    private func getCurrentProfilePicture() {
        mediaRepository.getImageWithUrl(url: user?.imageUrl) { image in
            self.profilePicture = image
        }
    }
    
    func logout() {
        logoutUseCase.execute()
    }
    
    func deleteUser() {
        Task {
            do {
                let result = try await userRepository.deleteUser()
                result.rawValue.log()
                logout()
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
    
    func deleteProfilePicture() {
        _Concurrency.Task {
            do {
                try await userRepository.deleteProfilePicture()
                self.profilePicture = nil
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
}
