//
//  TextExtension.swift
//
//
//  Created by Raul on 28/5/24.
//

import SwiftUI

extension Text {
    func customFont(size: CGFloat, color: Color? = nil) -> Text {
        var text = self
            text = text.font(.system(size: size))
        if let color = color {
            text = text.foregroundColor(color)
        }
        return text
    }
}
