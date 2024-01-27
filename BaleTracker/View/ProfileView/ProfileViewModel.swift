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
    
    // TODO: refactor create media repo class
    func getCurrentProfilePicture() {
        KingfisherManager.shared.cache.clearCache()
        if let url = user?.imageUrl {
            KingfisherManager.shared.retrieveImage(with: url, options: [.requestModifier(KFImage.authorizationModifier)]) { result in
                switch result {
                case .success(let image):
                    self.profilePicture = image.image
                    "Image fetched sucessfully".log(.info)
                case .failure(_):
                    "Failed to fetch image".log(.error)
                }
            }
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
//                logout()
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
