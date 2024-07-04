//
//  File.swift
//  
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

/**
 The main view for representing a loading indicator with customizable appearance.

 - Parameters:
    - type: The type of the loader, defined by the `LoaderType` enumeration.
    - color: The color of the loader. Default is blue.
    - dotCount: An optional number of dots for the loader, if applicable. Default is 4.
    - scale: The scale factor for the loader. Default is 1.5.

 - Note: The `LoaderType` enumeration defines different types of loaders.
 */
public struct LoaderContainer: View {
    let type: LoaderType
    var color: Color = .blue
    var dotCount: Int? = 4
    var scale: CGFloat = 1.5
    
    public init(type: LoaderType, color: Color, dotCount: Int? = nil, scale: CGFloat = 1.5) {
        self.type = type
        self.color = color
        self.dotCount = dotCount
        self.scale = scale
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                VStack {
                    Spacer()
                    loaderView
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    private var loaderView: some View {
        switch type {
        case .circularProgress:
            CircularProgressLoaderView(color: color, scale: scale)
        case .dots:
            DotsLoaderView(isAnimating: true, color: color, dotCount: dotCount ?? 4, maxScale: scale)
        case .pulsingCircle:
            PulsingCircleLoaderView(isAnimating: true, color: color, maxScale: scale)
        case .custom(let customView):
            customView()
        }
    }
}

#Preview {
    LoaderContainer(type: .dots, color: .red, scale: 1.5)
}
