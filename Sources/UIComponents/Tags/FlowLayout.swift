//
//  FlowLayout.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 1/6/25.
//

import SwiftUI

struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        var currentLineWidth: CGFloat = 0
        var currentLineHeight: CGFloat = 0
        
        for size in sizes {
            if currentLineWidth + size.width > proposal.width ?? .infinity {
                totalHeight += currentLineHeight
                currentLineWidth = size.width
                currentLineHeight = size.height
            } else {
                currentLineWidth += size.width
                currentLineHeight = max(currentLineHeight, size.height)
            }
            totalWidth = max(totalWidth, currentLineWidth)
        }
        totalHeight += currentLineHeight
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var currentX = bounds.minX
        var currentY = bounds.minY
        var currentLineHeight: CGFloat = 0
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += currentLineHeight
                currentLineHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            currentX += size.width
            currentLineHeight = max(currentLineHeight, size.height)
        }
    }
}
