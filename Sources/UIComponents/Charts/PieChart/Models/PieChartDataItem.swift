//
//  PieChartDataItem.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 15/8/25.
//

import Foundation
import SwiftUI

public struct PieChartDataItem: Identifiable, Hashable {
    public let id = UUID()
    let label: String
    let value: Double
    let color: Color
    let subtitle: String?
    
    public init(label: String, value: Double, color: Color, subtitle: String? = nil) {
        self.label = label
        self.value = value
        self.color = color
        self.subtitle = subtitle
    }
    
    var percentage: Double {
        // Percentage will be calculated relative to total in the view
        return 0.0
    }
}
