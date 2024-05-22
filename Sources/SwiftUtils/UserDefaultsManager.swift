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
    func saveStructToUserDefaults<T: Codable>(_ value: T, forKey key: String, suiteName: String? = nil) -> Bool {
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
    func loadStructFromUserDefaults<T: Codable>(_ type: T.Type, forKey key: String, suiteName: String? = nil) -> T? {
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
}
