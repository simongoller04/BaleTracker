//
//  Repository.swift
//  BaleTracker
//
//  Created by Simon Goller on 16.12.23.
//

import Foundation
import Moya

protocol Repository {
    associatedtype T: TargetType
    static var shared: Self { get }
    var apiHandler: APIRequestHandler<T> { get }
}
