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
        
    var body: some View {
        List {
            Section {
                VStack {
                    Button {
                        showConfirmationDialog = true
                    } label: {
                        ZStack {
                            farmPicture
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
            
            
            if let description = viewModel.farm.description {
                Section(R.string.localizable.description()) {
                    Text(description)
                }
            }
            
            if let coordinate = viewModel.farm.coordinate {
                LocationCell(region: coordinate.toMKCoordinateRegion())
                    .listRowInsets(EdgeInsets())
            }
            
            Section {
                memberSection
            } header: {
                if let count = viewModel.members?.count {
                    Text("\(R.string.pluralLocalizable.x_members(members: count))")
                        .font(.headline)
                        .foregroundStyle(Color(uiColor: .label))
                        .textCase(nil)
                }
            }
        }
    }
    
    @ViewBuilder
    private var farmPicture: some View {
        if let image = viewModel.farmPicture {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.2.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.gray)
                .font(.system(size: 140))
        }
    }
    
    private var profileHeader: some View {
        VStack {
            Text(viewModel.farm.name)
                .font(.largeTitle)
            Text("\(R.string.localizable.farm()) - \(R.string.pluralLocalizable.x_members(members: viewModel.farm.members.count))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
    FarmDetailView(viewModel: .init(farm: .fixture(_with: true)))
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    FarmDetailView(viewModel: .init(farm: .fixture()))
        .preferredColorScheme(.light)
}
