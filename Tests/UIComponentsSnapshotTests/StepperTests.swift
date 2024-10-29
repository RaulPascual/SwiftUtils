//
//  StepperTests.swift
//
//
//  Created by Raul on 10/7/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class StepperTests: XCTestCase {
    func testStepper() {
        let view = ExampleCustomStepper()
        
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
