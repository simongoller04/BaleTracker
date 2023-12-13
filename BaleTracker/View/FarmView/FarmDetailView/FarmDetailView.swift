//
//  FarmDetailView.swift
//  BaleTracker
//
//  Created by Simon Goller on 06.11.23.
//

import SwiftUI

struct FarmDetailView: View {
    @StateObject var viewModel: FarmDetailViewModel
        
    var body: some View {
        Text("Hello, World!")
    }
}

struct FarmDetailView_Preview: PreviewProvider {
    static var previews: some View {
        FarmDetailView(viewModel: FarmDetailViewModel(farm: Farm.fixture()))
            .darkPreview()
        
        FarmDetailView(viewModel: FarmDetailViewModel(farm: Farm.fixture()))
            .lightPreview()
    }
}
