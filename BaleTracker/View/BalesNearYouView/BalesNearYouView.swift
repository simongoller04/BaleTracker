//
//  BalesNearYouView.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.12.23.
//

import SwiftUI

struct BalesNearYouView: View {
    @EnvironmentObject private var locationPermission: LocationPermission
    @StateObject private var viewModel = BalesNearYouViewModel()
    @State private var selectedBale: Bale?
    
    var body: some View {
        VStack(spacing: 8) {
            filterHeader()
                .frame(height: 50, alignment: .center)
            
            List {
                Section {
                    if let bales = viewModel.bales {
                        ForEachWithIndex(data: bales) { index, bale in
                            Button {
                                selectedBale = bale
                            } label: {
                                baleListItem(bale: bale, index: index + 1)
                            }
                            .foregroundStyle(Color(uiColor: .label))
                            .swipeActions {
                                Button("Collect") {
                                    viewModel.collectBale(id: bale.id)
                                }
                                .tint(.accentColor)
                                
                                Button("Delete") {
                                    // TODO: Delete Bale
                                    print("Deleted!")
                                }
                                .tint(.red)
                            }
                        }
                    }
                } header: {
                    header(title: "All Bales:")
                        .textCase(nil)
                }
            }
        }
        .sheet(item: $selectedBale) { bale in
            BaleDetailView(bale: bale)
                .closeSheetHeader(title: "Details")
                .presentationDetents([.medium, .large])
                .environmentObject(locationPermission)
        }
    }
    
    private func filterHeader() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStackLayout(spacing: 8) {
                FilterItem(selection: $viewModel.selectedCrop, selectables: CropFilter.allCases)
                FilterItem(selection: $viewModel.selectedBaleType, selectables: BaleTypeFilter.allCases)
                FilterItem(selection: $viewModel.selectedTimeSpan, selectables: TimeFilter.allCases)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, Spacing.spacingM)
        }
    }
    
    private func header(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            VStack(spacing: 0) {
                let collected = viewModel.bales?.filter({ $0.collectedBy != nil }).count.description
                let allBales = viewModel.bales?.count.description
                Text("\(collected ?? "") of \(allBales ?? "")")
                    .font(.headline)
                Text(R.string.localizable.collected())
                    .font(.footnote)
            }
            .fullWidth(.trailing)
        }
    }
    
    private func baleListItem(bale: Bale, index: Int) -> some View {
        VStack {
            HStack {
                Text("Bale \(index):")
                if bale.collectedBy != nil {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color.accentColor)
                }
                Text(bale.creationTime.iso8601?.defaultDateFormat() ?? "")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fullWidth(.trailing)
            }
            .fullWidth(.leading)
            .padding(.top, Spacing.spacingS)

            HStack {
                detailCell(title: R.string.localizable.crop(), value: bale.crop.name)
                Divider()
                detailCell(title: R.string.localizable.type(), value: bale.baleType.name)
                Divider()
                detailCell(title: R.string.localizable.distance(), value: locationPermission.location?.distance(from: bale.location).distanceString() ?? "")
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

#Preview("Light") {
    BalesNearYouView()
        .preferredColorScheme(.light)
        .environmentObject(LocationPermission())
}

#Preview("Dark") {
    BalesNearYouView()
        .preferredColorScheme(.dark)
        .environmentObject(LocationPermission())
}
