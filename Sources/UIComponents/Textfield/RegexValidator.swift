//
//  File.swift
//  
//
//  Created by Raul on 18/6/24.
//

import SwiftUI

struct RegexValidator: ViewModifier {
    @Binding var text: String
    var regexPattern: String
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { _, newValue in
                if !newValue.matches(regexPattern) {
                    text = String(newValue.dropLast())
                }
            }
    }
}
