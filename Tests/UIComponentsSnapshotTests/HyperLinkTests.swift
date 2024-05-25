//
//  HyperLinkTests.swift
//
//
//  Created by Raul on 21/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

final class HyperLinkTests: XCTestCase {
    func testHyperLink() {
        let view = Hyperlink(text: "Go to developer site",
                             linkText: "developer",
                             url: URL(string: "https://example.com")!)
        
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
