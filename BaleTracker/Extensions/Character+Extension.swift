//
//  Character+Extension.swift
//  BaleTracker
//
//  Created by Simon Goller on 12.07.23.
//

import Foundation

extension Character {
    var isAsciiLetter: Bool { "A" ... "Z" ~= self || "a" ... "z" ~= self }
}

