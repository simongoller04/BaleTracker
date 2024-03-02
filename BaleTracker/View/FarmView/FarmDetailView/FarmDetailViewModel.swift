//
//  FarmDetailViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 06.11.23.
//

import Foundation
import UIKit
import Combine

@MainActor class FarmDetailViewModel: ObservableObject {
    private let mediaRepository = MediaRepository()
    private let publicUserRepository = PublicUserRepositoryImpl.shared
    private let userRepository = UserRepositoryImpl.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var farm: Farm
    @Published var selectedImage: UIImage?
    @Published var farmPicture: UIImage?
    @Published var uploadProgress = 0.0
    @Published var isUploading = false
    
    @Published var members: [User]?
    @Published var owner: User?
    @Published var user: User?
    
    init(farm: Farm) {
        self.farm = farm
        observeUser()
//        fetchOwner(id: farm.createdBy)
//        if let membersIds = farm.members {
        fetchMembers(ids: farm.members)
//        }
    }
    
    private func observeUser() {
        userRepository.$user
            .receive(on: DispatchQueue.main, options: .none)
            .sink { [self] user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    private func fetchMembers(ids: [String]) {
        Task {
            do {
                self.members = try await publicUserRepository.getUsers(ids: ids)
            } catch {
                error.localizedDescription.log(.error)
                print(error)
            }
        }
    }
    
    private func fetchOwner(id: String) {
        Task {
            do {
                self.owner = try await publicUserRepository.getUser(id: id)
            } catch {
                error.localizedDescription.log(.error)
            }
        }
    }
}
