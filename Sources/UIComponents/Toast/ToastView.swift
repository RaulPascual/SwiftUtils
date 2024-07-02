//
//  ToastView.swift
//
//
//  Created by Raul on 1/7/24.
//

import SwiftUI
/**
 A view representing a toast notification with customizable appearance.

 - Parameters:
    - message: The message text to be displayed in the toast.
    - style: The style of the toast, which determines its background color. Default is `.info`.
    - foregroundColor: The color of the message text. Default is white.
    - cornerRadius: The corner radius of the toast's background. Default is 8.
    - shadowRadius: The shadow radius of the toast's background. Default is 0.

 - Note: The `ToastStyle` enumeration defines different styles for the toast notification.
 */
public struct ToastView: View {
    let message: String
    var style: ToastStyle = .info
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 8
    var shadowRadius: CGFloat = 0
    
    public init(message: String, style: ToastStyle, foregroundColor: Color = .white,
                cornerRadius: CGFloat = 8, shadowRadius: CGFloat = 0) {
        self.message = message
        self.style = style
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    public var body: some View {
        VStack {
            Text(message)
                .padding()
                .background(style.backgroundColor.opacity(0.8))
                .foregroundColor(foregroundColor)
                .cornerRadius(cornerRadius)
                .shadow(radius: shadowRadius)
        }
    }
}

struct ExampleToastView: View {
    @Binding var isShowing: Bool
    var body: some View {
        VStack {
            Text("Toast View!")
        }
        .toast(isShowing: $isShowing, message: "Hi, this is a toast!", style: .custom(.mint), duration: 5.0)
    }
}

#Preview {
    ExampleToastView(isShowing: .constant(true))
}
