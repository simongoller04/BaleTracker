//
//  LogoHeader.swift
//  BaleTracker
//
//  Created by Simon Goller on 15.12.23.
//

import SwiftUI

struct LogoHeader: View {
    var text = "BaleTracker"
    
    var body: some View {
        VStack(spacing: 0) {
            Image(R.image.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            
            Text(text)
                .font(.largeTitle)
        }
    }
}

#Preview {
    LogoHeader()
}
