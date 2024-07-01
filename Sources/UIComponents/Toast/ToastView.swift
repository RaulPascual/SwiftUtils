//
//  ToastView.swift
//
//
//  Created by Raul on 1/7/24.
//

import SwiftUI

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

public enum ToastStyle {
    case error
    case success
    case info
    case warning
    
    var backgroundColor: Color {
        switch self {
        case .error:
            return Color.red
        case .success:
            return Color.green
        case .info:
            return Color.blue
        case .warning:
            return Color.yellow
        }
    }
}

struct ToastExampleView: View {
    @Binding var isShowing: Bool
    var body: some View {
        VStack {
            Text("Toast View!")
        }
        .toast(isShowing: $isShowing, message: "Hi, this is a toast!", style: .success, duration: 5.0)
    }
}

#Preview {
    ToastExampleView(isShowing: .constant(true))
}
