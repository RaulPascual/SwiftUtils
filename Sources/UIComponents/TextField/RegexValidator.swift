//
//  File.swift
//  
//
//  Created by Raul on 18/6/24.
//

import SwiftUI

public struct RegexValidator: ViewModifier {
    @Binding var text: String
    var regexPattern: String
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: text) { _, newValue in
                if !newValue.matches(regexPattern) {
                    text = String(newValue.dropLast())
                }
            }
    }
}
