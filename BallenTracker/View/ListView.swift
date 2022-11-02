//
//  ListView.swift
//  BallenTracker
//
//  Created by Simon Goller on 27.07.22.
//

import SwiftUI

// all the bales are represented in a list
struct ListView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var showPopOver: Bool
    
    var body: some View {
        List {
            ForEach($viewModel.baleArray) { $baleItem in
                baleListCell(bale: baleItem)
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button("Collect") {
                            baleItem.collected.toggle()
                        }
                        .tint(.green)
                    }
            }
            .onDelete(perform: deleteBale)
        }
    }
    
    func deleteBale(at offset: IndexSet) {
        viewModel.baleArray.remove(atOffsets: offset)
        viewModel.baleCounter -= 1
    }
}


struct baleListCell: View {
    var bale: bale
    
    var body: some View {
        HStack {
            Text("Bale: \(bale.number)")
                .font(.title3)
            
            VStack (alignment: .leading){
                Text(handleBaleType(baleType: bale.type))
                Text(handleCropType(cropType: bale.crop))
//                Text("longitude: \(bale.longitude)")
//                Text("latitude: \(bale.latitude)")
            }
            .padding(.leading, 30)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.green)
                .opacity(bale.collected ? 100 : 0.0)
            
            Button(action: {
                // add show point on map
            }, label: {
                Image(systemName: "mappin.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            })
            .frame(width: 40, height: 40)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}
