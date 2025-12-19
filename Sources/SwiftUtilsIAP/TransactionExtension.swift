//
//  TransactionExtension.swift
//
//
//  Created by Raul on 5/5/25.
//

import StoreKit

public extension Transaction {
    /// Returns true if the transaction is currently considered active.
    ///
    /// - For non-consumables: always true (unless revoked).
    /// - For consumables: always true (they are one-time use, validity is immediate).
    /// - For subscriptions: true if not expired and not revoked.
    ///
    /// - Parameter referenceDate: The date to compare against for expiration checks. Defaults to now.
    /// - Returns: A Boolean indicating whether the transaction is active.
    func isActive(at referenceDate: Date = Date()) -> Bool {
        // Revoked transactions are never active
        if revocationDate != nil {
            return false
        }

        switch productType {
        case .nonConsumable:
            return true

        case .consumable:
            // Consumables are valid immediately after purchase
            return true

        case .autoRenewable:
            guard let expirationDate else {
                return false
            }
            return expirationDate > referenceDate

        case .nonRenewable:
            guard let expirationDate else {
                return false
            }
            return expirationDate > referenceDate

        default:
            return false
        }
    }

    /// Returns true if the transaction is currently considered active (convenience property).
    ///
    /// This is equivalent to calling `isActive(at: Date())`.
    var isActive: Bool {
        isActive(at: Date())
    }

    /// Returns true if the product is an auto-renewable subscription.
    var isAutoRenewableSubscription: Bool {
        productType == .autoRenewable
    }

    /// Returns true if the product is a consumable.
    var isConsumable: Bool {
        productType == .consumable
    }

    /// Returns true if the product is a non-consumable.
    var isNonConsumable: Bool {
        productType == .nonConsumable
    }

    /// Returns true if the transaction has been revoked (refunded or cancelled by Apple).
    var isRevoked: Bool {
        revocationDate != nil
    }
}
