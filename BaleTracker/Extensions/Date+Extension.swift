//
//  Date+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 10.02.24.
//

import Foundation

extension Date {
    var iso8601: String { return Formatter.iso8601.string(from: self) }
    
    /// 10.09.2021
    func defaultDateFormat() -> String {
        let dateFormatter = DateFormatter(format: "dd.MM.yyyy")
        return dateFormatter.string(from: self)
    }
    
    /// NOV. 2024
    func shortDate() -> String {
        let dateFormatter = DateFormatter(format: "MMM yyyy")
        return dateFormatter.string(from: self)
    }
    
//    var startOfWeek: Date? {
//        let gregorian = Calendar(identifier: .gregorian)
//        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
//        return gregorian.date(byAdding: .day, value: 2, to: sunday)
//    }
//
//    var endOfWeek: Date? {
//        let gregorian = Calendar(identifier: .gregorian)
//        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
//        return gregorian.date(byAdding: .day, value: 8, to: sunday)
//    }
    
    // MARK: Day
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    
    // MARK: Week
    
    var startOfWeek: Date {
        let calendar = Calendar(identifier: .iso8601)
        return calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    var endOfWeek: Date {
        var components = DateComponents()
        components.day = 7
        components.second = -1
        return Calendar(identifier: .iso8601).date(byAdding: components, to: startOfWeek)!
    }
    
    // MARK: Month
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .iso8601)
        let components = calendar.dateComponents([.year, .month], from: self)

        return calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .iso8601).date(byAdding: components, to: startOfMonth)!
    }
    
    // MARK: Year
    
    var startOfYear: Date {
        let calendar = Calendar(identifier: .iso8601)
        let components = calendar.dateComponents([.year], from: self)

        return calendar.date(from: components)!
    }
    
    var endOfYear: Date {
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return Calendar(identifier: .iso8601).date(byAdding: components, to: startOfYear)!
    }
}
