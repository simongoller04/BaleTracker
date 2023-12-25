//
//  ContentViewModel.swift
//  BaleTracker
//
//  Created by Simon Goller on 05.11.23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var title: String = "test"

    private let baleRepository = BaleRepositoryImpl.shared

    func fetchBales() {
        baleRepository.fetchBales()
    }

    func uploadBale() {
        let dateFormatter = DateFormatter.iso8601withFractionalSeconds
        let newBale = Bale(id: nil, crop: .grass, baleType: .square, createdBy: "hans", collectedBy: "jürgen", creationTime: dateFormatter.string(from: Date()), collectionTime: dateFormatter.string(from: Date()), longitude: 0, latitude: 0)

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
