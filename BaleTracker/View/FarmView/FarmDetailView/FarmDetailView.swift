//
//  FarmDetailView.swift
//  BaleTracker
//
//  Created by Simon Goller on 06.11.23.
//

import SwiftUI
import Kingfisher

struct FarmDetailView: View {
    @StateObject var viewModel: FarmDetailViewModel
    @State private var showImagePicker = false
    @State private var showConfirmationDialog = false
    @State private var isEditing = false
    @State private var showLocationSelector = false
        
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack {
                        Button {
                            showConfirmationDialog = true
                        } label: {
                            farmPicture
                        }
                        .disabled(!isEditing)
                        profileHeader
                    }
                    .fullWidth()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(EmptyView())
                }
                
                
                if let description = viewModel.farm.description {
                    if isEditing {
                        Section {
                            CustomTextField(text: $viewModel.newDescription, placeholder: R.string.localizable.description(), isMultilineText: true, backgroundColor: .listBackground)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(EmptyView())
                    } else {
                        Section(R.string.localizable.description()) {
                            Text(description)
                        }
                    }
                } else {
                    if isEditing {
                        Section {
                            CustomTextField(text: $viewModel.newDescription, placeholder: R.string.localizable.description(), isMultilineText: true, backgroundColor: .listBackground)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(EmptyView())
                    }
                }
            
                Section {
                    locationSection
                }
                .listRowInsets(EdgeInsets())
                
                Section {
                    memberSection
                } header: {
                    if let count = viewModel.members?.count {
                        HStack {
                            Text("\(R.string.pluralLocalizable.x_members(members: count))")
                                .font(.headline)
                                .foregroundStyle(Color(uiColor: .label))
                                .textCase(nil)
                            
                            if !isEditing {
                                Button {
                                    // TODO: open sheet to add member
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .fullWidth(.trailing)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.farm.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showLocationSelector) {
            SelectFarmLocationView<FarmDetailViewModel>()
                .environmentObject(viewModel)
        }
        .toolbar {
            ToolbarItemGroup {
                if isEditing {
                    Button(R.string.localizable.cancel(), role: .cancel) {
                        viewModel.cancel()
                        isEditing = false
                    }
                    Button(R.string.localizable.done()) {
                        viewModel.updateFarm()
                        isEditing = false
                    }
                    .bold()
                } else {
                    Button(R.string.localizable.edit()) {
                        isEditing = true
                    }
                }
            }
        }
        .confirmationDialog("", isPresented: $showConfirmationDialog) {
            Button(R.string.localizable.selectFromGallery()) {
                showImagePicker = true
            }
            Button(R.string.localizable.deletePicture(), role: .destructive) {
                viewModel.deleteImage = true
            }
            Button(R.string.localizable.cancel(), role: .cancel) {
                showConfirmationDialog = false
            }
        }
    }
    
    @ViewBuilder
    private var farmPicture: some View {
        ZStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
            } else if viewModel.deleteImage {
                placeholder
            } else {
                KFImage(viewModel.farm.imageUrl)
                    .requestModifier(KFImage.authorizationModifier)
                    .placeholder {
                        placeholder
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
            }
        
            if isEditing {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 0.5)
                        .fill(.ultraThinMaterial)
                        .frame(width: 130, height: 130)
                    
                    Text(R.string.localizable.edit())
                        .padding(.top, 60)
                }
            }
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "person.2.circle.fill")
            .resizable()
            .scaledToFill()
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.gray)
            .frame(width: 140, height: 140)
    }
    
    private var profileHeader: some View {
        VStack {
            if isEditing {
                CustomTextField(text: $viewModel.newName, placeholder: R.string.localizable.namePlaceholder(), font: .largeTitle, backgroundColor: .listBackground, textalignment: .center)
            } else {
                Text(viewModel.farm.name)
                    .font(.largeTitle)
            }
            Text("\(R.string.localizable.farm()) - \(R.string.pluralLocalizable.x_members(members: viewModel.farm.members.count))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var locationSection: some View {
        if let region = viewModel.region {
            LocationCell(region: region) {
                if isEditing {
                    HStack {
                        Button(role: .destructive) {
                            viewModel.region = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button {
                            showLocationSelector = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .imageScale(.large)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        // Buttons need BorderlessButtonStyle in the hstack otherwise they will all be triggered at the same time
                    }
                }
            }
        } else {
            if isEditing {
                Button {
                    showLocationSelector = true
                } label: {
                    Label(R.string.localizable.addLocation(), systemImage: "mappin.and.ellipse")
                        .fullWidth(.center)
                }

            }
        }
    }
    
    @ViewBuilder
    private var memberSection: some View {
        if let members = viewModel.members {
            ForEach(members, id: \.id) { member in
                memberCell(user: member)
            }
        }
    }
    
    private func memberCell(user: User) -> some View {
        HStack {
            KFImage(user.imageUrl)
                .requestModifier(KFImage.authorizationModifier)
                .placeholder {
                    Image(systemName: "person.circle")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.primary)
                        .font(.system(size: 36))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                if viewModel.user == user {
                    Text(R.string.localizable.you())
                } else {
                    Text(user.username)
                    Text(user.email)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            if user.id == viewModel.farm.createdBy {
                Text(R.string.localizable.owner())
                    .foregroundStyle(.secondary)
                    .fullWidth(.trailing)
            }
        }
    }
}

#Preview("Dark") {
    NavigationStack {
        FarmDetailView(viewModel: .init(farm: .fixture(_with: true, hasCoordinate: false)))
            .preferredColorScheme(.dark)
    }
}

#Preview("Light") {
    NavigationStack {
        FarmDetailView(viewModel: .init(farm: .fixture(_with: true, hasCoordinate: false)))            .preferredColorScheme(.light)
    }
}
