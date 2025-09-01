//
//  TransactionExtension.swift
//  FormulaTracker
//
//  Created by Raul on 5/5/25.
//

import StoreKit

public extension Transaction {
    /// Returns true if the transaction is currently considered active.
    ///
    /// - For non-consumables: always true.
    /// - For subscriptions: true if not expired.
    var isActive: Bool {
        switch productType {
        case .nonConsumable:
            return true
            
        case .autoRenewable:
            if let expirationDate {
                return expirationDate > Date()
            }
            return false
            
        default:
            return false
        }
    }
    
    /// Returns true if the product is an auto-renewable subscription.
    var isAutoRenewableSubscription: Bool {
        productType == .autoRenewable
    }
    
    /// Returns true if the transaction has been cancelled.
    var isCancelled: Bool {
        revocationDate != nil
    }
}
