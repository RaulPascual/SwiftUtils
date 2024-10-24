//
//  SearchBarTests.swift
//
//
//  Created by Raul on 6/7/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class SearchBarTests: XCTestCase {
    func testsearchView() {
        let view = ExampleSearchBar()
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
