//
//  File.swift
//  
//
//  Created by Raul on 1/7/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

final class ToastViewTests: XCTestCase {
    func testToastView() {
        let view = ExampleToastView(isShowing: .constant(true))
        assertSnapshot(of: view,
                       as: .wait(for: 3, on: .image(precision: 1, layout: .device(config: .iPhone13Pro))))
    }
}
