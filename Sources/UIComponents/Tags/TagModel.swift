//
//  TagModel.swift
//
//
//  Created by Raul on 6/7/24.
//

import SwiftUI

public struct TagModel: Identifiable, Equatable{
    public let id = UUID()
    public var text: String
    public var color: Color
    public var isSelected: Bool = false
    
    public init(text: String, color: Color, isSelected: Bool = false) {
        self.text = text
        self.color = color
        self.isSelected = isSelected
    }
}
