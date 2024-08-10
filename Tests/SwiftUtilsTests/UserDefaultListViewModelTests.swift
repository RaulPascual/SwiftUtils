//
//  File.swift
//  
//
//  Created by Raul on 10/8/24.
//

import XCTest
@testable import SwiftUtilities

final class UserDefaultListViewModelTests: XCTestCase {
    var sut: UserDefaultListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = UserDefaultListViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFilteredUserDefaultsValues() {
        let numberOfValues = sut.userDefaults.count
        sut.filterText = "Languages"
        XCTAssertLessThan(sut.filteredUserDefaultsValues.count, numberOfValues)
    }
    
    func testAddUserDefaultsValue() {
        let numberOfValues = sut.userDefaults.count
        sut.addUserDefaultsValue(forKey: "testKey", value: "testValue")
        XCTAssertGreaterThan(sut.userDefaults.count, numberOfValues)
        sut.removeUserDefaultsValue(forKey: "testKey")
    }
    
    func testRemoveUserDefaultsValue() {
        let numberOfValues = sut.userDefaults.count
        sut.addUserDefaultsValue(forKey: "testKey", value: "testValue")
        XCTAssertGreaterThan(sut.userDefaults.count, numberOfValues)
        sut.removeUserDefaultsValue(forKey: "testKey")
        XCTAssertEqual(sut.userDefaults.count, numberOfValues)
    }
    
}
