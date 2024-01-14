//
//  ProfileView.swift
//  BaleTracker
//
//  Created by Simon Goller on 30.12.23.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showImagePicker = false
    @State private var showConfirmationDialog = false
    
    var body: some View {
        List {
            Section {
                VStack {
                    Button {
                        showConfirmationDialog = true
                    } label: {
                        ZStack {
                            profilePicture
                            if viewModel.isUploading {
                                ProgressView()
                            }
                        }
                    }
                    profileHeader
                }
                .fullWidth()
                .listRowBackground(EmptyView())
            }
            
            Section {
                HStack {
                    detailCell(title: "Created", value: "350")
                    Divider()
                    detailCell(title: "Collected", value: "100")
                }
            }
            
            Section {
                VStack {
                    ActionButton(text: "Logout") {
                        viewModel.logout()
                    }
                    
                    ActionButton(text: "Delete Account", backgroundColor: .red) {
                        viewModel.deleteUser()
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(EmptyView())
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
                .ignoresSafeArea()
        }
        .confirmationDialog("", isPresented: $showConfirmationDialog) {
            Button("Select image from gallery") {
                showImagePicker = true
            }
            .tint(Color.accentColor)
            Button("Delete profile picture", role: .destructive) {
                viewModel.deleteProfilePicture()
            }
            Button("Cancel", role: .cancel) {
                showConfirmationDialog = false
            }
            .tint(Color.accentColor)
        }
    }
    
    @ViewBuilder
    private var profilePicture: some View {
        if let image = viewModel.profilePicture {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 160)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.primary)
                .font(.system(size: 160))
        }
//        KFImage.url(viewModel.user?.imageUrl)
//            .forceRefresh()
//            .placeholder {
//                Image(systemName: "person.circle.fill")
//                    .symbolRenderingMode(.hierarchical)
//                    .foregroundStyle(.primary)
//                    .font(.system(size: 160))
//            }
//            .requestModifier(KFImage.authorizationModifier)
//            .resizable()
//            .scaledToFill()
//            .frame(width: 160, height: 160)
//            .clipShape(Circle())
    }
    
    private var profileHeader: some View {
        VStack {
            if let user = viewModel.user {
                Text(user.username)
                    .font(.title2)
                Text(user.email)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func detailCell(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Text(value)
        }
        .fullWidth(.leading)
    }
}

#Preview("Dark") {
    ProfileView()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    ProfileView()
        .preferredColorScheme(.light)
}
