//
//  AccountSettingsView.swift
//  BaleTracker
//
//  Created by Simon Goller on 14.01.24.
//

import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        List {
            Section {
                VStack {
                    ActionButton(text: "Logout") {
                        viewModel.logout()
                    }
                    
                    ActionButton(text: "Delete Account", backgroundColor: .red) {
                        viewModel.deleteUser()
                    }
                    
                    memberSince
                        .padding(.top, Spacing.spacingM)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(EmptyView())
            }
        }
    }
    
    private var memberSince: some View {
        HStack {
            Text("Member since:".uppercased())
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(viewModel.user?.creationTime.iso8601?.defaultDateFormat() ?? "")
                .font(.footnote)
        }
        .fullWidth(.center)
    }
}

#Preview {
    AccountSettingsView()
        .environmentObject(ProfileViewModel())
}
