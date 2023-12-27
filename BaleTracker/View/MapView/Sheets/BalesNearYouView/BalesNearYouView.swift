//
//  BalesNearYouView.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.12.23.
//

import SwiftUI

struct BalesNearYouView: View {
    @StateObject private var viewModel = BalesNearYouViewModel()
    
    var body: some View {
        List {
            Section {
                baleListItem()
                baleListItem()
                baleListItem()
                    .swipeActions {
                        Button("Collect") {
                            print("Collected!")
                        }
                        .tint(.accentColor)
                        
                        Button("Delete") {
                            print("Deleted!")
                        }
                        .tint(.red)
                    }
            } header: {
                header(title: "Near You:")
            }
            
            Section {
                baleListItem()
                baleListItem()
                baleListItem()
                baleListItem()
                baleListItem()
            } header: {
                header(title: "All Bales:")
            }
        }
    }
    
    private func header(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            VStack(spacing: 0) {
                Text("1 of 3")
                    .font(.headline)
                Text(R.string.localizable.collected())
                    .font(.footnote)
            }
            .fullWidth(.trailing)
        }
    }
    
    private func baleListItem() -> some View {
        HStack {
            Text("Bale 1")
            Image(systemName: "checkmark.circle")
                .fullWidth(.trailing)
                .foregroundStyle(Color.accentColor)
        }
    }
}

#Preview("Light") {
    BalesNearYouView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    BalesNearYouView()
        .preferredColorScheme(.dark)
}
