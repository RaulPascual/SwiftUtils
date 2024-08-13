//
//  KeychainManager.swift
//
//
//  Created by Raul on 12/8/24.
//

import Foundation
import Security

public class KeychainManager {
    // MARK: - Constants
    private enum KeychainConstants {
        static let service = kSecAttrService as String
        static let account = kSecAttrAccount as String
        static let `class` = kSecClass as String // Avoid reserved keyword class
        static let valueData = kSecValueData
        static let genericPassword = kSecClassGenericPassword
        static let returnData = kSecReturnData as String
    }
    
    // MARK: - Properties
    private let appIdentifier: String? = Bundle.main.bundleIdentifier ?? ""
    
    public init() {}
    
    // MARK: - Public Methods
    /**
     Reads the data associated with the specified key from the keychain.

     - Parameters:
        - valueKey: A string that serves as the key under which the data is stored in the keychain.

     - Returns:
        - The data associated with the specified key if it exists, or `nil` if the key is not found.

     - Throws:
        - `KeychainError.unhandledError`: If there is an error other than `errSecItemNotFound` when attempting to retrieve the item from the keychain.

     - Note:
        - This function interacts with the iOS Keychain to securely retrieve sensitive data.
     */
    public func read(valueKey: String) throws -> Data? {
        let query = [
            KeychainConstants.service: appIdentifier ?? "",
            KeychainConstants.account: valueKey,
            KeychainConstants.class: KeychainConstants.genericPassword,
            KeychainConstants.returnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        if status == errSecSuccess {
            return (result as? Data)
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /**
     Saves a codable item to the keychain with the specified key.

     - Parameters:
        - item: The item conforming to `Codable` that needs to be saved in the keychain.
        - valueKey: A string that serves as the key under which the item will be stored.

     - Throws:
        - `KeychainError.encodingFailed`: If the item could not be encoded to `Data`.
        - Any other error that may be thrown by the underlying `save(_ data: valueKey:)` method.

     - Note:
        - The item is first encoded into `Data` using `JSONEncoder` before being stored in the keychain.
        - This function allows for the secure storage of any `Codable` item in the keychain.
     */
    public func save<T>(_ item: T, valueKey: String) throws where T : Codable {
        do {
            let data = try JSONEncoder().encode(item)
            try save(data, valueKey: valueKey)
        } catch {
            throw KeychainError.encodingFailed(error: error)
        }
    }
    
    /**
     Deletes the data associated with the specified key from the keychain.

     - Parameters:
        - valueKey: A string that serves as the key under which the data is stored in the keychain.

     - Throws:
        - `KeychainError.unhandledError`: If there is an error other than `errSecItemNotFound` when attempting to delete the item from the keychain.

     - Note:
        - This function interacts with the iOS Keychain to securely remove sensitive data.
        - If the specified key does not exist, no action is taken and no error is thrown.
     */
    public func delete(valueKey: String) throws {
        let query = [
            KeychainConstants.service: appIdentifier ?? "",
            KeychainConstants.account: valueKey,
            KeychainConstants.class: KeychainConstants.genericPassword,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    // MARK: - Private Methods
    
    /**
     Reads and decodes a value from the keychain for the specified key.

     This function retrieves data from the keychain using the given key and decodes it into the specified type.

     - Parameters:
        - valueKey: The key used to retrieve the data from the keychain.
        - type: The type to which the data should be decoded. Must conform to `Codable`.

     - Throws: `KeychainError.decodingFailed` if the data cannot be decoded into the specified type.

     - Returns: The decoded value of the specified type, or `nil` if no data is found for the key.
     */
    private func read<T>(valueKey: String, type: T.Type) throws -> T? where T : Codable {
        do {
            guard let data = try read(valueKey: valueKey) else { return nil }
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw KeychainError.decodingFailed(error: error)
        }
    }
    
    /**
     Updates the keychain item with the specified data for the given key.

     This function updates an existing keychain item with new data. If the keychain item does not exist, it throws an error.

     - Parameters:
        - data: The data to update in the keychain.
        - valueKey: The key used to identify the keychain item to be updated.

     - Throws: `KeychainError.unhandledError` if the update operation fails.
     */
    private func update(_ data: Data, valueKey: String) throws {
        let query = [
            KeychainConstants.service: appIdentifier ?? "",
            KeychainConstants.account: valueKey,
            KeychainConstants.class: KeychainConstants.genericPassword
        ] as CFDictionary
        
        let attributesToUpdate = [KeychainConstants.valueData: data] as CFDictionary
        
        let status = SecItemUpdate(query, attributesToUpdate)
        
        if status != errSecSuccess {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /**
     Saves the given data to the keychain with the specified key.

     - Parameters:
        - data: The data to be saved in the keychain.
        - valueKey: A string that serves as the key under which the data will be stored.

     - Throws:
        - `KeychainError.unhandledError`: If there is an error other than a duplicate item when attempting to add the item to the keychain.

     - Note:
        - If the data already exists for the specified key, the existing data will be updated.
        - This function interacts with the iOS Keychain to securely store sensitive data.
     */
    private func save(_ data: Data, valueKey: String) throws {
        let query = [
            KeychainConstants.valueData: data,
            KeychainConstants.service: appIdentifier ?? "",
            KeychainConstants.account: valueKey,
            KeychainConstants.class: KeychainConstants.genericPassword
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            try update(data, valueKey: valueKey)
        } else if status != errSecSuccess {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
}

// MARK: - KeychainError
internal enum KeychainError: Error, LocalizedError {
    case unhandledError(status: OSStatus)
    case encodingFailed(error: Error)
    case decodingFailed(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .unhandledError(let status):
            return "Keychain error with status: \(status)"
        case .encodingFailed(let error):
            return "Failed to encode item: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode item: \(error.localizedDescription)"
        }
    }
}
