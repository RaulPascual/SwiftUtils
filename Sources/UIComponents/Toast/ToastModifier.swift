//
//  ToastModifier.swift
//  
//
//  Created by Raul on 1/7/24.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let style: ToastStyle
    let duration: TimeInterval = 4.0
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 8
    var shadowRadius: CGFloat = 0
    
    public init(
        isShowing: Binding<Bool>,
        message: String,
        style: ToastStyle,
        duration: TimeInterval = 4.0,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 8,
        shadowRadius: CGFloat = 0
    ) {
        self._isShowing = isShowing
        self.message = message
        self.style = style
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                VStack {
                    Spacer()
                    ToastView(
                        message: message,
                        style: style,
                        foregroundColor: foregroundColor,
                        cornerRadius: cornerRadius,
                        shadowRadius: shadowRadius
                    )
                        .transition(.slide)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isShowing = false
                                }
                            }
                        }
                }
                .padding(.bottom, 50)
                .animation(.easeInOut, value: isShowing)
            }
        }
    }
}
