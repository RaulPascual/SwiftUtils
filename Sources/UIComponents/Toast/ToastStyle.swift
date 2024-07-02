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
    case custom(Color)
    
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
        case .custom(let color):
                    return color
        }
    }
}
