//
//  IAPModel.swift
//
//
//  Created by Raul on 21/4/25.
//

import StoreKit
import Foundation

// MARK: - Error Handling

public struct IAPProduct: Identifiable, Purchaseable {
    public let product: Product
    
    public var id: String {
        product.id
    }
    
    public var isSubscription: Bool {
        product.type == .autoRenewable
    }
    
    public var isPurchased: Bool = false
    
    @MainActor
    public static func create(from product: Product) async -> IAPProduct {
        return IAPProduct(product: product)
    }
    
    @MainActor
    public static func loadAll(bundlePrefix: String, productIdentifiers: [String]) async throws -> [IAPProduct] {
        let ids = productIdentifiers.map { bundlePrefix + $0 }
        let products = try await Product.products(for: ids)
        
        var models: [IAPProduct] = []
        for product in products {
            let model = await IAPProduct.create(from: product)
            models.append(model)
        }
        return models
    }
}

public enum IAPError: Error {
    case transactionUnverified
}
