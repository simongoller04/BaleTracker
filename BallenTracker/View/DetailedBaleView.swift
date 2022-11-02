//
//  DetailedBaleView.swift
//  BallenTracker
//
//  Created by Simon Goller on 15.08.22.
//

import SwiftUI

struct DetailedBaleView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var bale: bale
//    @Binding var showSheet: Bool

    var body: some View {
        Text("Bale: \(bale.number)")
            .font(.title)
            .padding(.top, 16)
        
        Divider()
        
        List {
            Section(header: Text("Details").font(.headline)) {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Crop:")
                        Text("Type:")
                        Text("Collected:")
                    }
                    .padding(.trailing, 10)
                    
                    VStack (alignment: .leading) {
                        Text(handleCropType(cropType: bale.crop))
                        Text(handleBaleType(baleType: bale.type))
                        Text(bale.collected.description)
                    }
                }
            }
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        
        Button (action: {
            // do something
        }, label: {
            Label("Route", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
        })
        .padding([.leading, .trailing], 20)

        
        List {
            Button  {
//                ForEach($viewModel.baleArray) { $baleItem in
//                    if baleItem == bale {
//                        baleItem.collected.toggle()
//                    }
//                }
                
            } label: {
                Label("Collect", systemImage: "checkmark.circle.fill")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
//                    .background(.secondary)
//                    .cornerRadius(10)
                    .foregroundColor(.green)
            }
            
            Button  {
                //
            } label: {
                Label("Delete", systemImage: "trash.fill")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
                    .foregroundColor(.red)
            }
            

            Button  {
                //
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
            }
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.hidden)

    }
    ////                    Text("lat: \(bale.coordinate.latitude)")
    ////                    Text("lon: \(bale.coordinate.longitude)")
}

