import Foundation
import StoreKit
import Testing
@testable import SwiftUtilsIAP

struct EntitlementPolicyTests {
    private let now = Date(timeIntervalSince1970: 1_000)

    @Test func revocationsAndUpgradesRemoveAccess() {
        #expect(!IAPEntitlementPolicy.isActive(
            type: .nonConsumable, isRevoked: true, referenceDate: now
        ))
        #expect(!IAPEntitlementPolicy.isActive(
            type: .autoRenewable, isUpgraded: true,
            expirationDate: now.addingTimeInterval(60), referenceDate: now
        ))
        #expect(!IAPEntitlementPolicy.isActive(
            type: .autoRenewable, isRevoked: true,
            referenceDate: now, isInGracePeriod: true
        ))
    }

    @Test func gracePreservesAccessAfterPaidPeriodEnds() {
        #expect(IAPEntitlementPolicy.isActive(
            type: .autoRenewable, expirationDate: now.addingTimeInterval(-60),
            referenceDate: now, isInGracePeriod: true
        ))
        #expect(!IAPEntitlementPolicy.isActive(
            type: .autoRenewable, expirationDate: now, referenceDate: now
        ))
    }

    @Test func nonRenewingSubscriptionsRequireAppDefinedPeriod() {
        #expect(!IAPEntitlementPolicy.isActive(
            type: .nonRenewable, expirationDate: now.addingTimeInterval(60), referenceDate: now
        ))
        #expect(IAPEntitlementPolicy.isActive(
            type: .nonRenewable, referenceDate: now,
            nonRenewingExpirationDate: now.addingTimeInterval(60)
        ))
        #expect(!IAPEntitlementPolicy.isActive(
            type: .nonRenewable, referenceDate: now, nonRenewingExpirationDate: now
        ))
    }

    @Test func consumablesDoNotGrantPermanentAccess() {
        #expect(!IAPEntitlementPolicy.isActive(type: .consumable, referenceDate: now))
        #expect(IAPEntitlementPolicy.isActive(type: .nonConsumable, referenceDate: now))
    }

    @MainActor @Test func emptyPreviewHasNoEntitlements() {
        let store = IAPStore.preview
        #expect(store.products.isEmpty)
        #expect(store.purchasedProductIDs.isEmpty)
        #expect(!store.hasActivePurchases)
    }
}
