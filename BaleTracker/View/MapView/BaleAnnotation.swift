//
//  BaleAnnotation.swift
//  BaleTracker
//
//  Created by Simon Goller on 23.12.23.
//

import SwiftUI
import _MapKit_SwiftUI

struct BaleAnnotation: View {
    var bale: Bale
    var body: some View {
        if bale.collectedBy != nil {
            Image(R.image.bale_green)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .overlay {
                    Circle()
                        .stroke(Color(uiColor: UIColor.label), lineWidth: 2)
                        .frame(width: 50, height: 50)
                }
        } else {
            Image(R.image.bale_yellow)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .overlay {
                    Circle()
                        .stroke(Color(uiColor: UIColor.label), lineWidth: 2)
                        .frame(width: 50, height: 50)
                }
        }
    }
}

#Preview("Light") {
    Group {
        BaleAnnotation(bale: Bale.fixture())
        BaleAnnotation(bale: Bale.fixture(collected: true))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    Group {
        BaleAnnotation(bale: Bale.fixture())
        BaleAnnotation(bale: Bale.fixture(collected: true))
    }
    .preferredColorScheme(.dark)
}


