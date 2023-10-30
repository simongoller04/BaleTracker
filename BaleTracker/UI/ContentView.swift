//
//  ContentView.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.07.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Button("Networkcall") {
                viewModel.fetchBales()
            }
            
            Text(viewModel.title)
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var title: String = "test"
    
    private let baleRepository = BaleRepositoryImpl.shared
    
    func fetchBales() {
        baleRepository.fetchBales()
    }
    
    func uploadBale() {
        let bale = Bale(id: "1", crop: "Wheat", baleType: "Square", user: "John", longitude: 12.345, latitude: 67.89)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
