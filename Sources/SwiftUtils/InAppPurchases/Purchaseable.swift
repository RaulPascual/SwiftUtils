//
//  Purchaseable.swift
//
//
//  Created by Raul on 29/4/25.
//

import StoreKit

public protocol Purchaseable: Identifiable {
    var product: Product { get }
}

public extension Purchaseable {
    var id: String { product.id }
}
