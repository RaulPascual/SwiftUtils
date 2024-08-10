//
//  ArrayExtensionTests.swift
//
//
//  Created by Raul on 29/5/24.
//

import XCTest
import Foundation

@testable import SwiftUtilities

final class ArrayExtensionTests: XCTestCase {
    func testRemoveDuplicates() {
        let people = [
            Person(id: 1, name: "Alice"),
            Person(id: 2, name: "Bob"),
            Person(id: 1, name: "Alice"), // Duplicate
            Person(id: 3, name: "Charlie")
        ]
        
        let uniquePeople = people.uniqued()
        
        XCTAssertEqual(uniquePeople.count, 3)
        XCTAssertTrue(uniquePeople.contains(Person(id: 1, name: "Alice")))
        XCTAssertTrue(uniquePeople.contains(Person(id: 2, name: "Bob")))
        XCTAssertTrue(uniquePeople.contains(Person(id: 3, name: "Charlie")))
    }
}

struct Person: Hashable {
    let id: Int
    let name: String
}
