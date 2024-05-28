//
//  OnboardingViewTests.swift
//
//
//  Created by Raul on 21/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

final class OnboardingViewTests: XCTestCase {
    func testOnboardingView() {
        let view = onboardingTestView
        
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
