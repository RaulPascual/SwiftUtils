//
//  UserDefaultsManagerTests.swift
//  
//
//  Created by Raul on 22/5/24.
//

import XCTest
@testable import SwiftUtilities

final class UserDefaultsManagerTests: XCTestCase {
    
    func testSaveStructToUserDefaults() {
        let myStruct = TestStruct(name: "John", age: 30)
        let key = "testStructKey"
        let suiteName = "com.example.MyApp"
        
        let result = UserDefaultsManager.saveStructToUserDefaults(myStruct, forKey: key, suiteName: suiteName)
        
        XCTAssertTrue(result, "Saving struct to UserDefaults should return true")
        
        // Check if the struct was saved correctly
        let userDefaults = UserDefaults(suiteName: suiteName)!
        guard let data = userDefaults.data(forKey: key) else {
            XCTFail("Failed to retrieve data from UserDefaults")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let savedStruct = try decoder.decode(TestStruct.self, from: data)
            XCTAssertEqual(savedStruct.name, "John")
            XCTAssertEqual(savedStruct.age, 30)
        } catch {
            XCTFail("Failed to decode struct from UserDefaults: \(error)")
        }
    }
    
    func testLoadStructFromUserDefaults() {
        // Arrange
        let testStruct = TestStruct(name: "John", age: 30)
        let key = "myStructKey"
        let suiteName = "com.example.MyApp"
        
        // Save the struct to UserDefaults
        _ = UserDefaultsManager.saveStructToUserDefaults(testStruct, forKey: key, suiteName: suiteName)
        
        // Act
        let loadedStruct: TestStruct? = UserDefaultsManager.loadStructFromUserDefaults(TestStruct.self, forKey: key, suiteName: suiteName)
        
        // Assert
        XCTAssertNotNil(loadedStruct, "Loaded struct should not be nil")
        XCTAssertEqual(loadedStruct?.name, "John", "Loaded struct's name should be 'John'")
        XCTAssertEqual(loadedStruct?.age, 30, "Loaded struct's age should be 30")
    }
    
    func testRemoveUserDefaultsData() {
        let suiteName = "com.example.MyApp"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        let testKey = "myStructKey"
        
        let testStruct = TestStruct(name: "Test Name", age: 30)
        if let encodedData = try? JSONEncoder().encode(testStruct) {
            userDefaults.set(encodedData, forKey: testKey)
        }
        
        // Ensure the data was saved
        XCTAssertNotNil(userDefaults.data(forKey: testKey))
        
        UserDefaultsManager.removeUserDefaultsData(forKey: testKey, suiteName: suiteName)
        
        XCTAssertNil(userDefaults.data(forKey: testKey))
    }

}

struct TestStruct: Codable {
    let name: String
    let age: Int
}
