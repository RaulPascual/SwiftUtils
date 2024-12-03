//
//  ExperimentalFeatureViewTests.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 3/12/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class ExperimentalFeatureViewTests: XCTestCase {
    func testExperimentalFeatureView() {
        let view = ExperimentalFeatureView(icon: Image(systemName: "exclamationmark.bubble.fill"),
                                           message: LocalizedStringKey("Experimental Feature"))
        assertSnapshot(of: view,
                       as: .wait(for: 3, on: .image(precision: 1, layout: .device(config: .iPhone13Pro))))
    }
}
