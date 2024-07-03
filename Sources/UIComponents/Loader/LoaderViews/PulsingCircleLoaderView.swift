//
//  PulsingCircleLoaderView.swift
//
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

/**
 A view representing a pulsing circle loader animation with customizable appearance.

 - Parameters:
    - color: The color of the pulsing circle. Default is blue.
    - maxScale: The maximum scale factor for the pulsing circle during animation. Default is 1.0.

 - Note: This view animates a circle that pulses to indicate loading or progress.
 */
public struct PulsingCircleLoaderView: View {
    @State private var isAnimating: Bool = false
    var color: Color = .blue
    var maxScale: CGFloat = 1.0

    public init(isAnimating: Bool, color: Color, maxScale: CGFloat = 1.5) {
        self.isAnimating = isAnimating
        self.color = color
        self.maxScale = maxScale
    }
    
    public var body: some View {
        Circle()
            .fill(color)
            .frame(width: 50, height: 50)
            .scaleEffect(isAnimating ? maxScale : 0.5)
            .opacity(isAnimating ? 1.0 : 0.5)
            .animation(
                Animation
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                self.isAnimating = true
            }
    }
}

#Preview("PulsingCircleLoaderView") {
    PulsingCircleLoaderView(isAnimating: true, color: .blue, maxScale: 1.5)
}
