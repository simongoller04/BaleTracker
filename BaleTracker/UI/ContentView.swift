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
                viewModel.uploadBale()
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
        let dateFormatter = DateFormatter.iso8601withFractionalSeconds
        let newBale = Bale(id: nil, crop: .GRASS, baleType: .SQUARE, createdBy: "hans", collectedBy: "jürgen", creationTime: dateFormatter.string(from: Date()), collectionTime: dateFormatter.string(from: Date()), longitude: 0, latitude: 0)

        baleRepository.uploadBale(bale: newBale) { result in
            switch result {
            case .success(let recivedBale):
                if let id = recivedBale.id {
                    print(id)
                }
            case.failure(let error):
                print("Failed to upload the bale \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
