//
//  ArrayExtension.swift
//
//
//  Created by Raul on 29/5/24.
//

import Foundation

public extension Array where Element: Hashable {
    /**
     Returns an array with duplicate elements removed, preserving the order of the first occurrence of each element.

     - Returns: A new array containing only the unique elements of the original array, in the order they first appeared.
     */
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
