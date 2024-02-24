//
//  SelectMembersView.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import SwiftUI

struct SelectMembersView: View {
    @StateObject var viewModel: SelectMembersViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                gird
                .padding()
            }
            .fullHeight()
            
            ActionButton(isDisabled: viewModel.selectedUsers.isEmpty, text: "Add \(viewModel.selectedUsers.count) Members") {
                dismiss()
            }
            .padding(Spacing.spacingM)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(R.string.localizable.cancel()) {
                    viewModel.selectedUsers = []
                    dismiss()
                }
            }
        }
        .searchable(text: $viewModel.searchableText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: R.string.localizable.search())
        .scrollIndicators(.never)
        .navigationTitle(R.string.localizable.selectMembers())
        .interactiveDismissDisabled()
        .navigationBarBackButtonHidden(true)
    }
    
    private var gird: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)], spacing: 16) {
            if let users = viewModel.filterdUsers {
                ForEach(users, id: \.id) { user in
                    Button {
                        if viewModel.selectedUsers.contains(user) {
                            viewModel.selectedUsers.removeAll(where: { $0.id == user.id })
                        } else {
                            viewModel.selectedUsers.append(user)
                        }
                    } label: {
                        userCell(user: user)
                    }
                }
            }
        }
    }
    
    private func userCell(user: User) -> some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
//                if let picture = user.profilePicture {
//                    Image(data: picture)?
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 56, height: 56)
//                        .clipShape(Circle())
//                        .padding(.horizontal, Spacing.spacingXS)
//                } else {
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 56, height: 56)
//                        .foregroundStyle(Color(uiColor: UIColor.secondaryLabel))
//                        .padding(.horizontal, Spacing.spacingXS)
//                }
                
                if viewModel.selectedUsers.contains(user) {
                    Image(systemName: "checkmark.circle.fill")
                }

            }
        
            Text(user.username)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(uiColor: .label))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct SelectMembersView_Preview: PreviewProvider {
    static var previews: some View {
        SelectMembersView(viewModel: .init(members: .constant(User.fixture(amount: 4))))
            .lightPreview()
        
        SelectMembersView(viewModel: .init(members: .constant(User.fixture(amount: 4))))            
            .darkPreview()
    }
}
