//
//  BaleDetailView.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.12.23.
//

import SwiftUI

struct BaleDetailView: View {
    @EnvironmentObject private var location: LocationPermission
    @StateObject private var viewModel = BaleDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showDeletionAlert = false
    
    var bale: Bale
    
    var body: some View {
        Form {
            HStack {
                detailCell(title: R.string.localizable.crop(), value: bale.crop.name)
                Divider()
                detailCell(title: R.string.localizable.type(), value: bale.baleType.name)
                Divider()
                detailCell(title: R.string.localizable.distance(), value: location.location?.distance(from: bale.location).distanceString() ?? "")
            }
            
            Section {
                createdCell
                collectedCell
            }
            
            Section {
                Button {
                    showDeletionAlert = true
                } label: {
                    Label(R.string.localizable.delete(), systemImage: "trash.square.fill")
                        .foregroundStyle(.red)
                }
                Button {
                    viewModel.collectBale(id: bale.id)
                    dismiss()
                } label: {
                    Label(R.string.localizable.collect(), systemImage: "checkmark.square.fill")
                }
            }
        }
        .alert(R.string.localizable.deleteBale_title(), isPresented: $showDeletionAlert) {
            Button(R.string.localizable.delete(), role: .destructive) {
                viewModel.deleteBale(id: bale.id)
                dismiss()
            }
            Button(R.string.localizable.cancel(), role: .cancel) {
                showDeletionAlert = false
            }
        } message: {
            Text(R.string.localizable.deleteBale_message())
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
    
    @ViewBuilder
    private var collectedCell: some View {
        if let collector = bale.collectedBy {
            HStack {
                Label(R.string.localizable.collectedBy(), systemImage: "checkmark.square.fill")
                VStack(alignment: .trailing) {
                    Text(collector)
                    if let collectionTime = bale.collectionTime {
                        Text(collectionTime.iso8601?.defaultDateFormat() ?? "")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .fullWidth(.trailing)
            }
        }
    }
    
    private var createdCell: some View {
        HStack {
            Label {
                Text(R.string.localizable.createdBy())
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
        .environmentObject(LocationPermission())
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    BaleDetailView(bale: .fixture(collected: true))
        .environmentObject(LocationPermission())
        .preferredColorScheme(.light)
}
