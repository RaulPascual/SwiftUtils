//
//  CustomTextFieldTests.swift
//  
//
//  Created by Raul on 18/6/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class CustomTextFieldTests: XCTestCase {
    func testCustomTextField() {
        let view = ExampleCustomTextfieldView()
        assertSnapshot(of: view,
                       as: .wait(for: 3, on: .image(precision: 1, layout: .device(config: .iPhone13Pro))))
    }
}
