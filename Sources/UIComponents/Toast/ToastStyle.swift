//
//  ToastStyle.swift
//
//
//  Created by Raul on 1/7/24.
//

import SwiftUI

public enum ToastStyle {
    case error
    case success
    case info
    case warning
    case custom(Color, Image)
    
    public var backgroundColor: Color {
        switch self {
        case .error:
            return Color.red
        case .success:
            return Color.green
        case .info:
            return Color.blue
        case .warning:
            return Color.yellow
        case .custom(let color, _):
                    return color
        }
    }
    
    public var toastIcon: Image {
        switch self {
        case .error:
            return Image(systemName: "xmark.circle.fill")
            
        case .success:
            return Image(systemName: "checkmark.circle.fill")
            
        case .info:
            return Image(systemName: "info.circle.fill")
            
        case .warning:
            return Image(systemName: "exclamationmark.triangle.fill")
            
        case .custom(_, let icon):
            return icon
        }
    }
}
