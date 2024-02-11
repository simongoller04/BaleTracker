//
//  BaleFilter.swift
//  BaleTracker
//
//  Created by Simon Goller on 03.02.24.
//

import Foundation
import SwiftUI

protocol Filter: CaseIterable, Identifiable, Hashable {
    var id: Self { get }
    var name: String { get }
    var title: String { get }
    var systemImage: String { get }
}

enum CropFilter: String, Filter {
    case all = "ALL"
    case straw = "STRAW"
    case grass = "GRASS"
    case hay = "HAY"
    
    var id: Self { return self }
    var name: String {
        switch self {
        case .all:
            return "All Crops"
        case .straw:
            return "Straw"
        case .grass:
            return "Grass"
        case .hay:
            return "Hay"
        }
    }
    var title: String { return "Crop" }
    var systemImage: String { return "leaf.circle" }
}

enum BaleTypeFilter: String, Filter {
    case all = "ALL"
    case round = "ROUND"
    case square = "SQUARE"
    case round_wrapped = "ROUND_WRAPPED"
    case square_wrapped = "SQUARE_WRAPPED"
    
    var id: Self { return self }
    var name: String {
        switch self {
        case .all:
            return "All Types"
        case .round:
            return "Round"
        case .square:
            return "Square"
        case .round_wrapped:
            return "Round Wrapped"
        case .square_wrapped:
            return "Square Wrapped"
        }
    }
    var title: String { return "Baletype" }
    var systemImage: String { return "square.split.bottomrightquarter" }
}

enum TimeFilter: Filter {
    case daily
    case weekly
    case monthly
    case yearly
    case alltime
    
    var id: Self { return self }
    var name: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Montly"
        case .yearly:
            return "Yearly"
        case .alltime:
            return "Alltime"
        }
    }
    var title: String { return "Creation time"}
    var systemImage: String { return "calendar"}
}
