//
//  File.swift
//  
//
//  Created by Raul on 7/7/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

final class TagsTests: XCTestCase {
    func testSingleTagView() {
        let view = ExampleTagView()
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
    
    func testTagListView() {
        let view = ExampleTagsListView()
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
