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

extension String {
    var iso8601: Date? { return Formatter.iso8601.date(from: self) }
}

extension Formatter {
    /// Date formatter for ISO8601 dates with fractional seconds, e.g. "2022-10-19T14:28:18.185Z"
    static var iso8601DateFormatterWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
}
