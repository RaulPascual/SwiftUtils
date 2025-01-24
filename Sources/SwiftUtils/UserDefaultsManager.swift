//
//  UserDefaultsManager.swift
//
//
//  Created by Raul on 22/5/24.
//

import Foundation

public class UserDefaultsManager {
    /**
     Saves a struct conforming to the Codable protocol to UserDefaults.
     
     - Parameters:
     - value: The value of the struct to encode and save.
     - key: The key used to store the data in UserDefaults.
     - suiteName: The suite name to use when accessing UserDefaults. Default is nil.
     
     - Returns: A boolean value indicating whether the save operation was successful (true) or not (false).
     */
    public static func saveStructToUserDefaults<T: Codable>(_ value: T, forKey key: String, suiteName: String? = nil) -> Bool {
        let encoder = JSONEncoder()
        
        do {
            let encoded = try encoder.encode(value)
            let userDefaults: UserDefaults
            
            if let suiteName = suiteName {
                userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
            } else {
                userDefaults = UserDefaults.standard
            }
            
            userDefaults.set(encoded, forKey: key)
            userDefaults.synchronize() // Synchronize UserDefaults to ensure immediate save
            return true // Return true to indicate successful save
        } catch {
            print("Error saving struct to UserDefaults: \(error)")
            return false // Return false to indicate failure
        }
    }
    
    /**
     Loads a struct conforming to the Codable protocol from UserDefaults.
     
     - Parameters:
     - type: The type of the struct to decode.
     - key: The key used to store the data in UserDefaults.
     - suiteName: The suite name to use when accessing UserDefaults. Default is nil.
     
     - Returns: An instance of the struct if successfully decoded, otherwise nil.
     */
    public static func loadStructFromUserDefaults<T: Codable>(_ type: T.Type, forKey key: String, suiteName: String? = nil) -> T? {
        let decoder = JSONDecoder()
        
        let userDefaults: UserDefaults
        if let suiteName = suiteName {
            userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
        } else {
            userDefaults = UserDefaults.standard
        }
        
        if let data = userDefaults.data(forKey: key),
           let decoded = try? decoder.decode(type, from: data) {
            return decoded
        }
        
        return nil
    }
    
    /**
     Removes data from UserDefaults for a specified key.
     
     - Parameters:
     - key: The key for the data to be removed from UserDefaults.
     - suiteName: An optional suite name for accessing a specific user defaults suite. Default is nil.
     
     - Note: If `suiteName` is provided, the data will be removed from the specified suite. Otherwise, it will be removed from the standard UserDefaults.
     */
    public static func removeUserDefaultsData(forKey key: String, suiteName: String? = nil) {
        let userDefaults: UserDefaults
        if let suiteName = suiteName {
            userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            userDefaults = .standard
        }
        userDefaults.removeObject(forKey: key)
    }
    
    /**
     Removes a specific item from an array stored in `UserDefaults`.
     
     This method retrieves an array of codable and equatable items from `UserDefaults`, removes the specified item, and saves the updated array back to `UserDefaults`.
     
     - Parameters:
     - item: The item to be removed from the array.
     - key: The key under which the array is stored in `UserDefaults`.
     - suiteName: An optional string for the suite name to use (e.g., for app group sharing). Defaults to `nil`, which uses the standard `UserDefaults`.
     
     - Note:
     - If the array does not exist or the item is not found in the array, no changes are made.
     - The method relies on `Codable` for serialization and `Equatable` to identify matching items.
     */
    public static func removeItemFromArrayInUserDefaults<T: Codable & Equatable>(item: T, forKey key: String, suiteName: String? = nil) {
        if var array: [T] = loadStructFromUserDefaults([T].self, forKey: key, suiteName: suiteName) {
            array.removeAll { $0 == item }
            _ = saveStructToUserDefaults(array, forKey: key, suiteName: suiteName)
        }
    }
    
    /**
     Saves a value to `UserDefaults` under a specified key, with optional support for app groups.
     
     This method allows saving a value to a specific `UserDefaults` suite or the standard one if no suite is specified.
     
     - Parameters:
     - value: The value to store in `UserDefaults`.
     - key: The key under which to store the value.
     - suiteName: An optional string for the suite name to use (e.g., for app group sharing). Defaults to `nil`, which uses the standard `UserDefaults`.
     
     - Note: If the `suiteName` is provided but the suite cannot be created, the standard `UserDefaults` is used.
     */
    public static func saveToUserDefaults<T>(_ value: T, forKey key: String, suiteName: String? = nil) {
        let userDefaults: UserDefaults
        if let suiteName = suiteName {
            userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            userDefaults = .standard
        }
        userDefaults.set(value, forKey: key)
    }
    
    /**
     Retrieves a value from `UserDefaults` under a specified key, with optional support for app groups.
     
     This method fetches a value of a specified type from a specific `UserDefaults` suite or the standard one if no suite is specified.
     
     - Parameters:
     - key: The key for the value to retrieve from `UserDefaults`.
     - suiteName: An optional string for the suite name to use (e.g., for app group sharing). Defaults to `nil`, which uses the standard `UserDefaults`.
     
     - Returns: The value associated with the specified key, cast to the specified type, or `nil` if no value exists or the type cast fails.
     
     - Note: If the `suiteName` is provided but the suite cannot be created, the standard `UserDefaults` is used.
     */
    public static func getFromUserDefaults<T>(forKey key: String, suiteName: String? = nil) -> T? {
        let userDefaults: UserDefaults
        if let suiteName = suiteName {
            userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            userDefaults = .standard
        }
        return userDefaults.value(forKey: key) as? T
    }
}
