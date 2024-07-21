//
//  UIWindowExtension.swift
//
//
//  Created by Raul on 17/7/24.
//

import SwiftUI

#if DEBUG || DEV
extension UIWindow {
   override open var canBecomeFirstResponder: Bool {
       return true
   }

   override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       if motion == .motionShake {
           AppCoordinator.shared.isDebugViewActive.toggle()
       }
   }
}
#endif
