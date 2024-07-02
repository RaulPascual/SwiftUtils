//
//  CircularProgressLoaderView.swift
//
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

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
