//
//  String+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.07.23.
//

import Foundation
import os.log

extension String: Identifiable {
    public typealias ID = Int

    public var id: Int {
        return hash
    }

    /// Logs to console in debug mode
    func log(_ logType: OSLogType = .default) {
        #if DEBUG
            os_log("%@", type: logType, self)
        #endif
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }

    var base64: String? {
        if let data = data(using: String.Encoding.utf8) {
            return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        }
        return nil
    }

    var base64UrlEncode: String {
        if let data = data(using: String.Encoding.utf8) {
            return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        }
        return self
    }

    /// Return true if the string is numeric
    var isNumeric: Bool {
        return Double(self) != nil
    }

    /// Returns true if first character of string is a ascii letter
    var startsWithAsciiLetter: Bool { first?.isAsciiLetter == true }

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func toDate() -> Date? {
        return DateFormatter.yearMonthDayDateFormatter.date(from: self)
    }

    func getCountryName() -> String {
        return Locale.current.localizedString(forRegionCode: self) ?? ""
    }
}

extension Optional where Wrapped == String {
    /// Returns true if the string is empty or nil
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }

    /// Returns an empty string
    var orEmpty: String {
        return self ?? ""
    }
}
