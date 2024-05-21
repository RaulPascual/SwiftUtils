//
//  ImageViwerTests.swift
//
//
//  Created by Raul on 21/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

final class ImageViwerTests: XCTestCase {
    func testImageViwer() {
        let view = ImageViwer(image: Image(systemName: "globe"))
        
        assertSnapshot(of: view,
                       as: .image(precision: 1, layout: .device(config: .iPhone13)))
    }
}
