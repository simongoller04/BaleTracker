//
//  DateDecodingStrategy+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 13.01.24.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    /// Date decoding strategy for decoding dates with (e.g. "2022-10-19T14:28:18.185Z") and without fractional seconds (e.g. "2022-10-19T14:28:18Z")
    static var iso8601WithFractionalSeconds = custom { decoder in

        let dateStr = try decoder.singleValueContainer().decode(String.self)

        if let date = Formatter.iso8601DateFormatterWithFractionalSeconds.date(from: dateStr) {
            return date
        } else if let date = ISO8601DateFormatter().date(from: dateStr) {
            return date
        } else if let date = DateFormatter.yearMonthDayDateFormatter.date(from: dateStr) {
            return date
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode date: \(dateStr)"))
    }
}
