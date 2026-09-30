//
//  TransactionExtension.swift
//
//
//  Created by Raul on 5/5/25.
//

import StoreKit

public extension Transaction {
    /// Evaluates durable access. A transaction alone cannot describe billing grace
    /// or an app-defined non-renewing period; supply that context when applicable.
    /// For the store's complete access snapshot, prefer currentEntitlements.
    /// Consumables never represent a durable entitlement.
    func isActive(
        at referenceDate: Date = Date(),
        isInGracePeriod: Bool = false,
        nonRenewingExpirationDate: Date? = nil
    ) -> Bool {
        IAPEntitlementPolicy.isActive(
            type: productType,
            isRevoked: revocationDate != nil,
            isUpgraded: isUpgraded,
            expirationDate: expirationDate,
            referenceDate: referenceDate,
            isInGracePeriod: isInGracePeriod,
            nonRenewingExpirationDate: nonRenewingExpirationDate
        )
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

/// Pure entitlement rules, separate from StoreKit fetching and UI publication.
internal enum IAPEntitlementPolicy {
    static func isActive(
        type: Product.ProductType,
        isRevoked: Bool = false,
        isUpgraded: Bool = false,
        expirationDate: Date? = nil,
        referenceDate: Date,
        isInGracePeriod: Bool = false,
        nonRenewingExpirationDate: Date? = nil
    ) -> Bool {
        guard !isRevoked, !isUpgraded else { return false }
        switch type {
        case .nonConsumable:
            return true
        case .autoRenewable:
            return isInGracePeriod || expirationDate.map { $0 > referenceDate } == true
        case .nonRenewable:
            return nonRenewingExpirationDate.map { $0 > referenceDate } == true
        default:
            return false
        }
    }
}
