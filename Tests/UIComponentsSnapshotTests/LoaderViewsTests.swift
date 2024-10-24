//
//  LoaderViewsTests.swift
//
//
//  Created by Raul on 3/7/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class LoaderViewsTests: XCTestCase {
    func testCircularLoader() {
        let view = CircularProgressLoaderView(color: .red, scale: 1.5)
        
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
    
    func testDotsLoader() {
        let view = DotsLoaderView(isAnimating: true, color: .cyan, dotCount: 5)

        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
    
    func testPulsingLoader() {
        let view = PulsingCircleLoaderView(isAnimating: true, color: .purple, maxScale: 3)

        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
