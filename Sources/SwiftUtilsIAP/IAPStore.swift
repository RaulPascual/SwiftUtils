//
//  IAPStore.swift
//
//
//  Created by Raul on 21/4/25.
//

import StoreKit

/// A store manager responsible for handling In-App Purchases (IAP) within the app.
///
/// This class loads available products, manages purchase transactions, and keeps track of purchased product identifiers.
/// It observes transaction updates in the background to handle new purchases or restorations.
///
/// Note: This class requires network connectivity to load products and verify transactions.
@MainActor
public final class IAPStore: ObservableObject {
    /// The list of available IAP products loaded from the App Store.
    @Published public private(set) var products: [IAPProduct] = []
    
    /// The set of product identifiers that have been purchased.
    public private(set) var purchasedProductIDs: Set<String> = []
    
    /// A background task that listens for transaction updates asynchronously.
    private var task: Task<Void, Never>?
    
    /// Initializes the store by loading all available products, syncing current purchases,
    /// and setting up a detached background task to listen for transaction updates.
    ///
    /// - Throws: An error if loading products fails.
    public init(bundlePrefix: String, productIdentifiers: [String]) async throws {
        products = try await IAPProduct.loadAll(bundlePrefix: bundlePrefix, productIdentifiers: productIdentifiers)
        
        _ = await self.syncPurchases()
        
        // Detach a background task to continuously observe transaction updates.
        // This ensures the app responds to new purchases or restorations even after initial load.
        task = Task.detached(priority: .background) { [weak self] in
            guard let self else {
                return
            }
            for await result in Transaction.updates {
                try? await self.processTransaction(result: result)
            }
        }
    }
    
    /// Initializes the store with a mock list of products, useful for previews or testing.
    ///
    /// - Parameter mockProducts: An array of `IAPProduct` used to simulate available products.
    public init(mockProducts: [IAPProduct]) {
        self.products = mockProducts
    }
    
    /// Provides a preview instance of the store with no products.
    public static var preview: IAPStore {
        IAPStore(mockProducts: [])
    }
    
    /// Indicates whether there are any active purchases.
    ///
    /// Returns `true` if at least one product has been purchased, otherwise `false`.
    public var hasActivePurchases: Bool {
        !purchasedProductIDs.isEmpty
    }
    
    deinit {
        // Cancel the background task observing transaction updates when the store is deallocated.
        task?.cancel()
    }
    
    /// Initiates the purchase process for a given product.
    ///
    /// This method attempts to purchase the specified product, then processes the transaction result.
    ///
    /// - Parameter purchaseable: The `IAPProduct` to be purchased.
    /// - Throws: An error if the purchase or transaction processing fails.
    public func buy(_ purchaseable: IAPProduct) async throws {
        let result = try await purchaseable.product.purchase()
        switch result {
        case .success(let verificationResult):
            try await processTransaction(result: verificationResult)
            
        case .pending, .userCancelled:
            // No action needed if the purchase is pending or cancelled by the user.
            break
            
        @unknown default:
            break
        }
    }
    
    /// Restores previously completed purchases by syncing current entitlements.
    ///
    /// - Returns: A Boolean indicating whether any purchases were restored.
    public func restorePurchases() async -> Bool {
        await syncPurchases()
    }
    
    /// Presents the App Store's promotional code redemption sheet.
    ///
    /// This method allows users to redeem promotional codes generated from the Apple Developer Portal.
    /// The system handles the entire redemption flow including validation and transaction processing.
    /// - Note: This method is only available on iOS. On other platforms, it does nothing.
    public func presentPromoCodeRedemption() {
#if os(iOS)
        Task { @MainActor in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }

            do {
                try await AppStore.presentOfferCodeRedeemSheet(in: windowScene)
            } catch {
                print("Error presenting promo code sheet: \(error)")
            }
        }
#else
        print("Promo code redemption is not available on this platform")
#endif
    }
    
    /// Processes a transaction verification result.
    ///
    /// If the transaction is verified, it updates the purchased products list,
    /// marks the product as purchased if it's active, and finishes the transaction.
    ///
    /// - Parameter result: The verification result of a transaction.
    /// - Throws: `IAPError.transactionUnverified` if the transaction is not verified.
    private func processTransaction(result: VerificationResult<Transaction>) async throws {
        guard case .verified(let transaction) = result else {
            throw IAPError.transactionUnverified
        }
        
        // Always finish the transaction
        await transaction.finish()
        
        // Only update purchased list if the subscription or product is currently active
        if transaction.isActive {
            purchasedProductIDs.insert(transaction.productID)
            
            if let index = products.firstIndex(where: { $0.id == transaction.productID }) {
                products[index].isPurchased = true
            }
        }
    }
    
    /// Synchronizes the current entitlements by fetching all verified transactions.
    ///
    /// This method clears the current purchased product IDs and repopulates them
    /// based on current entitlements, updating the products' purchase status accordingly.
    ///
    /// - Returns: A Boolean indicating whether any purchases were found during synchronization.
    private func syncPurchases() async -> Bool {
        var restored = false
        
        purchasedProductIDs.removeAll()
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.isActive {
                purchasedProductIDs.insert(transaction.productID)
                if let index = products.firstIndex(where: { $0.id == transaction.productID }) {
                    products[index].isPurchased = true
                }
                restored = true
            }
        }
        return restored
    }
}
