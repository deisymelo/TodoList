//
//  KeychainWrapper.swift
//  TodoList
//
//  Created by Deisy Melo on 9/06/24.
//

import Foundation
import Security

protocol KeychainManager {
    @discardableResult
    func saveData(_ data: Data, forKey key: String) -> Bool
    func getData(forKey key: String) -> Data?
    @discardableResult
    func deleteData(forKey key: String) -> Bool
}

final class KeychainWrapper: KeychainManager {
    enum Constants {
        static let accessTokenKey = "sessionToken"
    }
    
    func saveData(_ data: Data, forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getData(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            return result as? Data
        }

        return nil
    }

    func deleteData(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
