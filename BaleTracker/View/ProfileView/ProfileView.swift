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
        NavigationView {
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
                        detailCell(title: R.string.localizable.created(), value: "350")
                        Divider()
                        detailCell(title: R.string.localizable.collected(), value: "100")
                    }
                }
                
                Section {
                    NavigationLink {
                        AccountSettingsView()
                            .environmentObject(viewModel)
                    } label: {
                        Label(R.string.localizable.account(), systemImage: "gear")
                    }
                    NavigationLink {
                        // TODO: implement
                        EmptyView()
                    } label: {
                        Label(R.string.localizable.farms(), systemImage: "house")
                    }
                    NavigationLink {
                        // TODO: implement
                        EmptyView()
                    } label: {
                        Label(R.string.localizable.friends(), systemImage: "person.2")
                    }
                    NavigationLink {
                        // TODO: implement
                        EmptyView()
                    } label: {
                        Label(R.string.localizable.statistics(), systemImage: "chart.line.uptrend.xyaxis")
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
                    .ignoresSafeArea()
            }
            .confirmationDialog("", isPresented: $showConfirmationDialog) {
                Button(R.string.localizable.selectFromGallery()) {
                    showImagePicker = true
                }
                Button(R.string.localizable.deletePicture(), role: .destructive) {
                    viewModel.deleteProfilePicture()
                }
                Button(R.string.localizable.cancel(), role: .cancel) {
                    showConfirmationDialog = false
                }
            }
        }
    }
    
    @ViewBuilder
    private var profilePicture: some View {
        if let image = viewModel.profilePicture {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.gray)
                .font(.system(size: 140))
        }
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
