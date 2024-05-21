//
//  SlidingTabView.swift
//
//
//  Created by Raul on 21/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

final class SlidingTabViewTests: XCTestCase {
    func testSlidingTabView() {
        let view = SlidingTabView(selectionState: 0,
                                  selection: .constant(0),
                                  tabs: ["Tab 1", "Tab 2", "Tab 3"],
                                  inactiveTabColor: .gray,
                                  activeTabColor: .blue)
        
        assertSnapshot(of: view,
                       as: .image(precision: 1, layout: .fixed(width: 300, height: 600)))
    }
}
