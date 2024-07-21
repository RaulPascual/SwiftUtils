//
//  UserDefaultListViewModel.swift
//
//
//  Created by Raul on 21/7/24.
//

import Foundation

public class UserDefaultListViewModel: ObservableObject {
    var userDefaults: [String: Any] = [:]
    var keyText = ""
    var valueText = ""
    var filterText = ""
    
    var filteredUserDefaultsValues: [String: Any] {
        if filterText.isEmpty {
            return userDefaults
        } else {
            return userDefaults.filter { item in
                let containsKey = item.key.localizedCaseInsensitiveContains(filterText)
                return containsKey
            }
        }
    }
    
    /**
     Retrieves all values stored in the standard `UserDefaults`.

     This function fetches all key-value pairs stored in the standard `UserDefaults` and returns them as a dictionary.

     - Returns: A dictionary containing all key-value pairs stored in the standard `UserDefaults`.
     */
    func getAllUserDefaultsValues() -> [String: Any] {
        let userDefaults = UserDefaults.standard
        return userDefaults.dictionaryRepresentation()
    }
    
    /**
     Removes a value from the standard `UserDefaults` for the specified key.

     This function removes the value associated with the given key from the standard `UserDefaults`.

     - Parameter key: The key whose value should be removed from the `UserDefaults`.
     */
    func removeUserDefaultsValue(forKey key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
    
    /**
     Adds a value to the standard `UserDefaults` for the specified key.

     This function sets the value for the given key in the standard `UserDefaults` and updates the local `userDefaults` property with all the current key-value pairs.

     - Parameters:
        - key: The key with which to associate the value.
        - value: The value to store in the `UserDefaults`.
     */
    func addUserDefaultsValue(forKey key: String, value: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        self.userDefaults = self.getAllUserDefaultsValues()
    }
}
