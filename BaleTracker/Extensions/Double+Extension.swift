//
//  Double+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 27.01.24.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func distanceString() -> String {
        if self < 1000 {
            return "\(self.rounded(toPlaces: 2)) m"
        } else {
            return "\((self / 1000).rounded(toPlaces: 2)) km"
        }
    }
}
