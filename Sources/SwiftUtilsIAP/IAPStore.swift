//
//  IAPStore.swift
//
//
//  Created by Raul on 21/4/25.
//

import StoreKit
import Observation
import Foundation

/// Manages non-consumables and subscriptions using verified StoreKit entitlements.
/// Consumables require a separate persistent, idempotent delivery system.
@MainActor
@Observable
public final class IAPStore {
    public private(set) var products: [IAPProduct] = []
    public private(set) var purchasedProductIDs: Set<String> = []
    public private(set) var productLoadingError: Error?
    public private(set) var transactionProcessingError: Error?

    private let productIDs: Set<String>
    private let nonRenewingSubscriptionDurations: [String: TimeInterval]
    @ObservationIgnored private var task: Task<Void, Never>?
    @ObservationIgnored private var startupTask: Task<Void, Never>?
    @ObservationIgnored private var refreshTask: Task<Bool, Never>?
    @ObservationIgnored private var refreshRequested = false
    @ObservationIgnored private var catalogGeneration = 0

    /// Creates a store immediately, starts listening, and loads entitlements and the
    /// catalog independently. Retain this store at app scope from launch.
    ///
    /// Duration keys are full product IDs. Each non-renewing purchase grants access
    /// for the configured number of seconds after its purchase date. Stacking or
    /// server-managed subscription periods require a different entitlement policy.
    public init(
        productIDs: [String],
        nonRenewingSubscriptionDurations: [String: TimeInterval] = [:]
    ) {
        self.productIDs = Set(productIDs)
        self.nonRenewingSubscriptionDurations = nonRenewingSubscriptionDurations
        startListening()
        startupTask = Task { [weak self] in
            guard let self else { return }
            _ = await self.refreshPurchases()
            await self.recoverUnfinishedTransactions()
            do {
                try await self.reloadProducts()
            } catch {
                // reloadProducts exposes the error without disabling the listener.
            }
        }
    }

    /// Compatibility initializer. Catalog failures are exposed through
    /// productLoadingError so that the store and its listener remain usable.
    /// Prefer init(productIDs:) when the UI must appear without waiting for loading.
    public convenience init(
        bundlePrefix: String,
        productIdentifiers: [String],
        nonRenewingSubscriptionDurations: [String: TimeInterval] = [:]
    ) async throws {
        self.init(
            productIDs: productIdentifiers.map { bundlePrefix + $0 },
            nonRenewingSubscriptionDurations: nonRenewingSubscriptionDurations
        )
        await startupTask?.value
    }

    /// Creates an inert store for previews; does not start StoreKit tasks.
    public init(mockProducts: [IAPProduct]) {
        self.productIDs = Set(mockProducts.map(\.id))
        self.nonRenewingSubscriptionDurations = [:]
        self.products = mockProducts
        self.purchasedProductIDs = Set(mockProducts.filter(\.isPurchased).map(\.id))
    }

    public static var preview: IAPStore { IAPStore(mockProducts: []) }
    public var hasActivePurchases: Bool { !purchasedProductIDs.isEmpty }

    deinit {
        task?.cancel()
        startupTask?.cancel()
        refreshTask?.cancel()
    }

    /// Retries catalog loading without resetting existing entitlements.
    public func reloadProducts() async throws {
        catalogGeneration += 1
        let generation = catalogGeneration
        do {
            let loaded = try await Product.products(for: Array(productIDs))
            guard generation == catalogGeneration else { return }
            products = loaded.map {
                IAPProduct(product: $0, isPurchased: purchasedProductIDs.contains($0.id))
            }
            productLoadingError = nil
        } catch {
            if generation == catalogGeneration { productLoadingError = error }
            throw error
        }
    }

    public func buy(_ purchaseable: IAPProduct) async throws {
        guard productIDs.contains(purchaseable.id) else { throw IAPError.productNotFound }
        try validateSupport(type: purchaseable.product.type, productID: purchaseable.id)
        let result = try await purchaseable.product.purchase()
        switch result {
        case .success(let verificationResult):
            try await processTransaction(result: verificationResult)
        case .pending, .userCancelled:
            break
        @unknown default:
            break
        }
    }

    /// Call only in response to the user's Restore Purchases action, as StoreKit
    /// may request authentication. Returns whether supported entitlements exist
    /// after synchronization; it does not indicate that new purchases were found.
    @discardableResult
    public func restorePurchases() async throws -> Bool {
        try await AppStore.sync()
        await recoverUnfinishedTransactions()
        return await refreshPurchases()
    }

    /// Refresh local entitlements without prompting for authentication. Call when
    /// the app returns to the foreground, including after redeeming outside the app.
    /// Overlapping refresh requests are coalesced and trigger a fresh pass before
    /// publication, so a transaction update cannot be overwritten by an older pass.
    @discardableResult
    public func refreshPurchases() async -> Bool {
        refreshRequested = true
        if let refreshTask { return await refreshTask.value }
        let refresh = Task { @MainActor in
            defer { self.refreshTask = nil }
            var ids = Set<String>()
            repeat {
                self.refreshRequested = false
                ids = []
                for await result in Transaction.currentEntitlements {
                    guard case .verified(let transaction) = result,
                          self.productIDs.contains(transaction.productID),
                          transaction.revocationDate == nil,
                          !transaction.isUpgraded else { continue }
                    switch transaction.productType {
                    case .nonConsumable, .autoRenewable:
                        // currentEntitlements includes subscriptions in billing
                        // grace; expirationDate alone would incorrectly deny them.
                        ids.insert(transaction.productID)
                    case .nonRenewable:
                        if let expiration = self.nonRenewingExpiration(for: transaction),
                           transaction.isActive(nonRenewingExpirationDate: expiration) {
                            ids.insert(transaction.productID)
                        }
                    default:
                        break
                    }
                }
                if Task.isCancelled { return self.hasActivePurchases }
            } while self.refreshRequested

            // No suspension while publishing the complete snapshot, including removals.
            self.purchasedProductIDs = ids
            self.products = self.products.map {
                IAPProduct(product: $0.product, isPurchased: ids.contains($0.id))
            }
            return !ids.isEmpty
        }
        refreshTask = refresh
        return await refresh.value
    }

    private func startListening() {
        task = Task { [weak self] in
            for await result in Transaction.updates {
                guard !Task.isCancelled, let self else { break }
                await self.handleTransaction(result)
            }
        }
    }

    private func recoverUnfinishedTransactions() async {
        for await result in Transaction.unfinished {
            guard !Task.isCancelled else { return }
            await handleTransaction(result)
        }
    }

    private func handleTransaction(_ result: VerificationResult<Transaction>) async {
        do {
            try await processTransaction(result: result)
        } catch {
            transactionProcessingError = error
        }
    }

    private func processTransaction(result: VerificationResult<Transaction>) async throws {
        guard case .verified(let transaction) = result else {
            throw IAPError.transactionUnverified
        }
        // Leave unrelated and unsupported transactions for their delivery owner.
        guard productIDs.contains(transaction.productID) else { return }
        try validateSupport(type: transaction.productType, productID: transaction.productID)
        _ = await refreshPurchases()
        guard !Task.isCancelled else { return }
        // Access has now been reconciled and published, including revocations.
        await transaction.finish()
    }

    private func validateSupport(type: Product.ProductType, productID: String) throws {
        switch type {
        case .nonConsumable, .autoRenewable:
            return
        case .nonRenewable:
            guard let duration = nonRenewingSubscriptionDurations[productID],
                  duration.isFinite, duration > 0 else {
                throw IAPError.missingSubscriptionDuration(productID: productID)
            }
        default:
            throw IAPError.unsupportedProductType
        }
    }

    private func nonRenewingExpiration(for transaction: Transaction) -> Date? {
        guard let duration = nonRenewingSubscriptionDurations[transaction.productID],
              duration.isFinite, duration > 0 else { return nil }
        return transaction.purchaseDate.addingTimeInterval(duration)
    }
}
