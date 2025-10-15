//
//  UIWindowExtension.swift
//
//
//  Created by Raul on 17/7/24.
//

#if os(iOS)
import SwiftUI


extension UIWindow {
    override open var canBecomeFirstResponder: Bool {
        return true
    }

    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
#if DEBUG
            AppCoordinator.shared.isDebugViewActive.toggle()
#endif
        }
    }
}
#endif
