//
//  CheckboxTests.swift
//  
//
//  Created by Raul on 17/6/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

final class CheckboxTests: XCTestCase {
    func testCheckBox() {
        let view = ExampleCheckBoxView()
        
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
