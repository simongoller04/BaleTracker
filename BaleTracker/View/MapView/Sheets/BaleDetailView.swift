//
//  BaleDetailView.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.12.23.
//

import SwiftUI

struct BaleDetailView: View {
    var bale: Bale
    @EnvironmentObject private var location: LocationPermission
    
    var body: some View {
        Form {
            HStack {
                detailCell(title: "Crop", value: bale.crop.name)
                Divider()
                detailCell(title: "Type", value: bale.baleType.name)
                Divider()
                detailCell(title: "Distance", value: location.location?.distance(from: bale.location).distanceString() ?? "")
            }
            
            Section {
                createdCell
                collectedCell
            }
            
            Section {
                Button {
                    //
                } label: {
                    Label("Delete", systemImage: "trash.square.fill")
                        .foregroundStyle(.red)
                }
                
                Button {
                    //
                } label: {
                    Label("Collect", systemImage: "checkmark.square.fill")
                }
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
    
    private var collectedCell: some View {
        HStack {
            Label("Collected", systemImage: "checkmark.square.fill")
            VStack(alignment: .trailing) {
                if let collectedBy = bale.collectedBy, let collectionTime = bale.collectionTime {
                    Text(collectedBy)
                    Text(collectionTime.iso8601?.defaultDateFormat() ?? "")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .fullWidth(.trailing)
        }
    }
    
    private var createdCell: some View {
        HStack {
            Label {
                Text("Created")
            } icon: {
                Image(systemName: "plus.square.fill")
                    .foregroundStyle(.yellow)
            }
            VStack(alignment: .trailing) {
                Text(bale.createdBy)
                Text(bale.creationTime.iso8601?.defaultDateFormat() ?? "")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .fullWidth(.trailing)
        }
    }
}

#Preview("Dark") {
    BaleDetailView(bale: .fixture(collected: true))
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    BaleDetailView(bale: .fixture(collected: true))
        .preferredColorScheme(.light)
}
