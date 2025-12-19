//
//  IAPModel.swift
//
//
//  Created by Raul on 21/4/25.
//

import StoreKit
import Foundation

public struct IAPProduct: Identifiable, Purchaseable {
    public let product: Product

    public var id: String {
        product.id
    }

    public var isSubscription: Bool {
        product.type == .autoRenewable
    }

    public var isConsumable: Bool {
        product.type == .consumable
    }

    public var isNonConsumable: Bool {
        product.type == .nonConsumable
    }

    public var isPurchased: Bool = false

    public init(product: Product, isPurchased: Bool = false) {
        self.product = product
        self.isPurchased = isPurchased
    }

    /// Loads all products from the App Store matching the given identifiers.
    ///
    /// - Parameters:
    ///   - bundlePrefix: The bundle prefix to prepend to each product identifier.
    ///   - productIdentifiers: An array of product identifier suffixes.
    /// - Returns: An array of `IAPProduct` instances.
    /// - Throws: An error if the products cannot be loaded from the App Store.
    @MainActor
    public static func loadAll(bundlePrefix: String, productIdentifiers: [String]) async throws -> [IAPProduct] {
        guard !productIdentifiers.isEmpty else {
            return []
        }

        let ids = productIdentifiers.map { bundlePrefix + $0 }
        let products = try await Product.products(for: ids)

        return products.map { IAPProduct(product: $0) }
    }
}

// MARK: - Error Handling

public enum IAPError: Error, LocalizedError {
    case transactionUnverified
    case productNotFound
    case purchaseFailed(underlying: Error?)
    case networkError
    case userNotAuthenticated
    case unknown

    public var errorDescription: String? {
        switch self {
        case .transactionUnverified:
            return "The transaction could not be verified."
        case .productNotFound:
            return "The requested product was not found."
        case .purchaseFailed(let underlying):
            if let error = underlying {
                return "Purchase failed: \(error.localizedDescription)"
            }
            return "Purchase failed."
        case .networkError:
            return "A network error occurred. Please check your connection."
        case .userNotAuthenticated:
            return "User is not authenticated with the App Store."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
