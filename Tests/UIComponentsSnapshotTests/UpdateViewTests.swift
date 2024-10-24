//
//  UpdateViewTests.swift
//  
//
//  Created by Raul on 28/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class UpdateViewTests: XCTestCase {
    func testUpdateView() {
        let view = exampleUpdateView()
        assertSnapshot(of: view,
                       as: .wait(for: 3, on: .image(precision: 1, layout: .device(config: .iPhone13Pro))))
    }
}
