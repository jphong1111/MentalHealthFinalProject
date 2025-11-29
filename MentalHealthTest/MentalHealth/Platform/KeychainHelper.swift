//
//  KechaingHelper.swift
//  MentalHealth
//
//  Created by JungpyoHong on 3/6/25.
//

import Foundation
import Security

final class KeychainHelper {
    static let shared = KeychainHelper()

    private init() {}

    // Save password in Keychain
    func savePassword(_ password: String, for account: String) {
        let passwordData = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData,
            kSecAttrService as String: "com.soliu.MentalHealth"
        ]
        
        // Delete existing password if it exists
        SecItemDelete(query as CFDictionary)
        
        // Add new password
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving password: \(status)")
        }
    }

    // Retrieve password from Keychain
    func getPassword(for account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrService as String: "com.soliu.MentalHealth"
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data,
              let password = String(data: retrievedData, encoding: .utf8) else {
            print("Error retrieving password: \(status)")
            return nil
        }
        
        return password
    }

    func deletePassword(for account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: "com.soliu.MentalHealth"
        ]
        
        // First, check if the item exists
        var item: CFTypeRef?
        let statusCheck = SecItemCopyMatching(query as CFDictionary, &item)
        
        if statusCheck == errSecItemNotFound {
            print("🔍 No password found for account: \(account)")
            return
        }
        
        // Attempt to delete if found
        let statusDelete = SecItemDelete(query as CFDictionary)
        if statusDelete == errSecSuccess {
            print("🗑️ Password deleted successfully for account: \(account)")
        } else {
            print("❌ Error deleting password for account \(account): \(statusDelete)")
        }
    }
}
