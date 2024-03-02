//
//  CreateNewFarmView.swift
//  BaleTracker
//
//  Created by Simon Goller on 07.11.23.
//

import SwiftUI
import MapKit

struct CreateNewFarmView: View {
    @StateObject private var viewModel = CreateNewFarmViewModel()
    @State private var showImagePicker = false
    @State private var showMemberSelector = false
    @State private var showLocationSelector = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            CircularButton(imageSystemName: "camera", image: viewModel.selectedImage) {
                                showImagePicker = true
                            }
                            TextField(R.string.localizable.namePlaceholder(), text: $viewModel.name)
                        }
                        
                        TextField(R.string.localizable.description(), text: $viewModel.description)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Section("\(R.string.localizable.members()): \(viewModel.members?.count ?? 0)") {
//                        addMembersSection
                        // TODO: fetch all friends
                    }
                    .listRowInsets(EdgeInsets())
                    
                    addHomeAddress
                        .listRowInsets(EdgeInsets())
                }
                .fullHeight()
                
                ActionButton(isLoading: viewModel.isUploading, isDisabled: !viewModel.isFormValid, text: R.string.localizable.createFarm()) {
                    viewModel.createFarm()
                    dismiss()
                }
                .padding([.horizontal], Spacing.spacingM)
            }
            .navigationTitle(R.string.localizable.newFarm())
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .navigationDestination(isPresented: $showMemberSelector) {
                SelectMembersView(viewModel: .init(members: $viewModel.members))
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(R.string.localizable.cancel()) {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showLocationSelector) {
                SelectFarmLocationView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var addHomeAddress: some View {
        Button {
            showLocationSelector = true
        } label: {
            if let region = viewModel.region {
                LocationCell(region: region) {
                    Button(role: .destructive) {
                        viewModel.region = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                    }
                }
            } else {
                Label(R.string.localizable.addLocation(), systemImage: "mappin.and.ellipse")
                    .fullWidth(.center)
            }
        }
    }
    
    private func member(user: User) -> some View {
        ZStack (alignment: .bottomTrailing) {
//            if let picture = user.profilePicture {
//                Image(data: picture)?
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 56, height: 56)
//                    .clipShape(Circle())
//                    .padding(.horizontal, Spacing.spacingXS)
//            } else {
//                Image(systemName: "person.circle.fill")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 56, height: 56)
//                    .foregroundStyle(Color(uiColor: UIColor.secondaryLabel))
//                    .padding(.horizontal, Spacing.spacingXS)
//            }
//            
            Image(systemName: "xmark.circle.fill")
                .padding(.leading, Spacing.spacingM)
                .foregroundStyle(Color(uiColor: UIColor.secondaryLabel))
        }
    }
    
//    private var addMembersSection: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            LazyHStack(spacing: 2) {
//                CircularButton(imageSystemName: "plus") {
//                    showMemberSelector = true
//                }
//                .padding(.trailing, Spacing.spacingS)
//                
//                ForEach($viewModel.members, id: \.id) { user in
//                    Button {
//                        viewModel.members.removeAll(where: { $0.id == user.id})
//                    } label: {
//                        member(user: user.wrappedValue)
//                    }
//                }
//            }
//            .padding(20)
//        }
//    }
}

struct CreateNewFarmView_Preview: PreviewProvider {
    static var previews: some View {
        CreateNewFarmView()
            .lightPreview()
        
        CreateNewFarmView()
            .darkPreview()
    }
}
