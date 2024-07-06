//
//  TagModel.swift
//
//
//  Created by Raul on 6/7/24.
//

import SwiftUI

public struct TagModel: Identifiable {
    public let id = UUID()
    var text: String
    var color: Color
    var isSelected: Bool = false
}
