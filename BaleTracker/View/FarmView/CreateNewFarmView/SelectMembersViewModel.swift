//
//  SelectMembersViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import Foundation
import Combine
import SwiftUI

class SelectMembersViewModel: ObservableObject {
    @Published var searchableText = ""
    @Published var filterdUsers: [User]?
    @Published var selectedUsers: [User] = []
    @Binding var members: [User]
    
    private var users: [User]?
    
    private var subscriptions = Set<AnyCancellable>()
    private let userRepository = UserRepositoryImpl.shared
    
    init(members: Binding<[User]>) {
        _members = members
        fetchUsers()
        addSubscribtion()
    }
    
    // MARK: - private functions
    
    private func addSubscribtion() {
        $searchableText
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                filterUsers()
            }.store(in: &subscriptions)
        
        $selectedUsers
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] users in
                members = users
            }.store(in: &subscriptions)
    }
    
    private func filterUsers() {
        if let users = users {
            if searchableText.isEmpty {
                filterdUsers = users
            } else {
                filterdUsers = users.filter {
                    $0.username.localizedCaseInsensitiveContains(searchableText)
                }
            }
        }
    }
    
    // MARK: - functions
    
    func fetchUsers() {
        Task {
            try? await users = userRepository.fetchAllUsers()
            self.users = users
            filterdUsers = users
        }
    }
}
