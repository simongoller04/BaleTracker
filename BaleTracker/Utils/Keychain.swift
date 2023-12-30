//
//  Keychain.swift
//  BaleTracker
//
//  Created by Simon Goller on 30.12.23.
//

import Foundation
import Security

class KeyChain {
    // MARK: Keys (add new keys here)

    enum Keys: String {
        case token = "keyToken"
        case firstName
        case lastName
        case pendingFCMPushToken
        case successfullySentFCMPushToken
        case videoCookie
    }

    // MARK: Public functions

    @discardableResult class func save(key: KeyChain.Keys, string: String) -> Bool {
        return save(key: key.rawValue, string: string)
    }

    @discardableResult class func save<T: Encodable>(key: KeyChain.Keys, encodable: T) -> Bool {
        return save(key: key.rawValue, encodable: encodable)
    }

    @discardableResult class func save(key: KeyChain.Keys, data: Data) -> Bool {
        return save(key: key.rawValue, data: data)
    }

    class func load(key: KeyChain.Keys) -> String? {
        return load(key: key.rawValue)
    }

    class func load<T: Decodable>(key: KeyChain.Keys) -> T? {
        return load(key: key.rawValue)
    }

    @discardableResult class func delete(key: KeyChain.Keys) -> Bool {
        return delete(key: key.rawValue)
    }

    /// Deletes all items from the Keychain
    class func clear() {
        let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }

    // MARK: Private functions

    private class func save(key: String, string: String) -> Bool {
        if let data = string.data(using: .utf8) {
            return save(key: key, data: data)
        }
        return false
    }

    private class func save<T: Encodable>(key: String, encodable: T) -> Bool {
        if let data = try? JSONEncoder().encode(encodable) {
            return save(key: key, data: data)
        }
        return false
    }

    private class func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ] as [String: Any]

        let result = SecItemAdd(query as CFDictionary, nil)

        "Keychain save of \(key) result: \(result)".log()

        if result == errSecDuplicateItem {
            return update(key: key, data: data)
        } else {
            return result == errSecSuccess
        }
    }

    private class func update(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
        ] as [String: Any]

        let attributesToUpdate = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ] as [String: Any] as CFDictionary

        let result = SecItemUpdate(query as CFDictionary, attributesToUpdate)
        "Keychain update of \(key) result: \(result)".log()

        return result == errSecSuccess
    }

    private class func load(key: String) -> String? {
        if let data: Data = load(key: key) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    private class func load<T: Decodable>(key: String) -> T? {
        if let data: Data = load(key: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }

    private class func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ] as [String: Any]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        "Keychain load of \(key) result: \(status)".log()

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

    private class func delete(key: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
        ] as [String: Any]

        let result = SecItemDelete(query as CFDictionary)
        "Keychain delete of \(key) result: \(result)".log()

        return result == errSecSuccess
    }
}
