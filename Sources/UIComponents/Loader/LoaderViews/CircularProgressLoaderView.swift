//
//  CircularProgressLoaderView.swift
//
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

/**
 A view representing a circular progress loader with customizable appearance.

 - Parameters:
    - color: The color of the loader. Default is blue.
    - scale: The scale factor for the loader. Default is 1.5.

 - Note: This view can be used to indicate ongoing progress or loading state.
 */
public struct CircularProgressLoaderView: View {
    var color: Color = .blue
    var scale: CGFloat = 1.5
    
    public init(color: Color, scale: CGFloat) {
        self.color = color
        self.scale = scale
    }
    
    public var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(scale)
            .padding()
    }
}

#Preview("Circular") {
    CircularProgressLoaderView(color: .black, scale: 3)
}
