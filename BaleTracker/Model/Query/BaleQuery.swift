//
//  BaleQuery.swift
//  BaleTracker
//
//  Created by Simon Goller on 03.02.24.
//

import Foundation

struct BaleQuery: Codable {
    let crop: String?
    let baleType: String?
    let createdBy: String?
    let creationTime: TimeSpan?
    let collectedBy: String?
    let collectionTime: TimeSpan?
    let coordinate: Coordinate?
    let farm: String?
}

struct TimeSpan: Codable {
    let start: String
    let end: String
    
    init(with _filter: TimeFilter) {
        switch _filter {
        case .daily:
            start = Date().startOfDay.iso8601
            end = Date().endOfDay.iso8601
        case .weekly:
            start = Date().startOfWeek.iso8601
            end = Date().endOfWeek.iso8601
        case .monthly:
            start = Date().startOfMonth.iso8601
            end = Date().endOfMonth.iso8601
        case .yearly:
            start = Date().startOfYear.iso8601
            end = Date().endOfYear.iso8601
        case .alltime:
            start = Date().startOfWeek.iso8601
            end = Date().endOfWeek.iso8601
        }
    }
}
