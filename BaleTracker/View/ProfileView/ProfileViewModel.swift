//
//  ProfileViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 30.12.23.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    private let logoutUseCase = LogoutUseCase()
    private let userRepository = UserRepositoryImpl.shared
    
    private var cancellables = Set<AnyCancellable>()

    @Published var user: User?
    
    init() {
        observeUser()
    }
    
    private func observeUser() {
        userRepository.$user
            .receive(on: DispatchQueue.main, options: .none)
            .sink(receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
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
}
