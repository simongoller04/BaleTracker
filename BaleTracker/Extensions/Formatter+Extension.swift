//
//  Formatter+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 28.12.23.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension DateFormatter {
    /// Create a new formatter with format string.
    convenience init(format: String, timeZone: TimeZone = .current, locale: String? = nil) {
        self.init()
        dateFormat = format
        self.timeZone = timeZone
        if let locale = locale {
            self.locale = Locale(identifier: locale)
        }
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withFractionalSeconds, .withInternetDateTime])
    static let iso8601WithoutFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime])
}

extension Date {
    var iso8601: String { return Formatter.iso8601.string(from: self) }
    
    /// 10.09.2021
    func defaultDateFormat() -> String {
        let dateFormatter = DateFormatter(format: "dd.MM.yyyy")
        return dateFormatter.string(from: self)
    }
    
    func shortDate() -> String {
        let dateFormatter = DateFormatter(format: "MMM yyyy")
        return dateFormatter.string(from: self)
    }
}

extension String {
    var iso8601: Date? { return Formatter.iso8601.date(from: self) }
}
