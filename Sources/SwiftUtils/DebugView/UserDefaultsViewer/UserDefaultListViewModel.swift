//
//  UserDefaultListViewModel.swift
//
//
//  Created by Raul on 21/7/24.
//

import Foundation

public class UserDefaultListViewModel: ObservableObject {
    @Published var userDefaults: [String: Any] = [:]
    @Published var keyText = ""
    @Published var valueText = ""
    @Published var filterText = ""
    
    var filteredUserDefaultsValues: [String: Any] {
        if filterText.isEmpty {
            return userDefaults
        } else {
            return userDefaults.filter { item in
                item.key.localizedCaseInsensitiveContains(filterText)
            }
        }
    }
    
    init() {
        self.userDefaults = getAllUserDefaultsValues()
    }
    
    /**
     Retrieves all values stored in the standard `UserDefaults`.

     - Returns: A dictionary containing all key-value pairs currently stored in the standard `UserDefaults`.
     */
    func getAllUserDefaultsValues() -> [String: Any] {
        return UserDefaults.standard.dictionaryRepresentation()
    }
    
    /**
     Removes the value for the specified key from the standard `UserDefaults`.

     This function removes the value associated with the given key from the standard `UserDefaults` and updates the local representation of all user defaults values.

     - Parameters:
        - key: The key whose value should be removed from the `UserDefaults`.
     */
    func removeUserDefaultsValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        self.userDefaults = getAllUserDefaultsValues()
    }
    
    /**
     Adds a value to the standard `UserDefaults` for the specified key.

     This function sets the value for the given key in the standard `UserDefaults`.

     - Parameters:
        - key: The key with which to associate the value.
        - value: The value to store in the `UserDefaults`.
     */
    func addUserDefaultsValue(forKey key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
        self.userDefaults = getAllUserDefaultsValues()
    }
}
