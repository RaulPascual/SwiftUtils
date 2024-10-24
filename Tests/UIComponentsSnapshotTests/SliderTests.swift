//
//  File.swift
//  
//
//  Created by Raul on 10/8/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class SliderTests: XCTestCase {
    func testSlider() {
        let view = ExampleCustomSlider()
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
