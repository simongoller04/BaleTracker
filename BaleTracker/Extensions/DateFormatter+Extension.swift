//
//  DateFormatter+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.07.23.
//

import Foundation

extension DateFormatter {
    /// eg. "OCT 20, 2022"
    static var monthDayYearDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormat.monthDateYearFormat
        return formatter
    }

    /// eg. "2022-12-19"
    static var yearMonthDayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormat.yearMonthDayFormat
        return formatter
    }

    /// eg. "Fri, Jul 30"
    static var weekdayMonthDayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormat.weekdayMonthDayFormat
        return formatter
    }

    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormat.timeFormat
        return formatter
    }
}

enum DateFormat {
    /// eg. "OCT 20, 2022"
    fileprivate static let monthDateYearFormat = "MMM dd, y"

    /// eg. "2022-12-19"
    fileprivate static let yearMonthDayFormat = "yyyy-MM-dd"

    /// eg. "Fri, Jul 30"
    fileprivate static let weekdayMonthDayFormat = "EEE, MMM d"

    /// eg. "15:00:00"
    fileprivate static let timeFormat = "HH:mm:ss"
}
