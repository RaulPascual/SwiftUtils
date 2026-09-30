# Swift Utils

Welcome to the SwiftUI Components and Utilities SPM repository! This Swift Package Manager (SPM) package is designed to streamline your Swift development by providing a collection of reusable SwiftUI components and useful utilities for day-to-day development tasks.

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white) ![Apple](https://img.shields.io/badge/Apple-%23000000.svg?style=for-the-badge&logo=apple&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Deployment

To use this SPM, add the following URL as dependency in your project

```
  https://github.com/RaulPascual/SwiftUtils
```
# Features

## In-App Purchases

Retain one `IAPStore` at app scope from launch. The synchronous initializer starts
transaction observation immediately and loads purchases and products asynchronously:

```swift
let store = IAPStore(productIDs: ["com.example.app.premium"])
```

`IAPStore` uses Observation (`@Observable`), with no Combine or UIKit imports.
Use `@State` instead of `@StateObject` for an owned store, a plain `let` for an
injected store, or `.environment(store)` and `@Environment(IAPStore.self)` instead
of `.environmentObject` and `@EnvironmentObject`. Combine subscriptions to the
store's former `$products` and other publishers must migrate to Observation.

The store no longer has `presentPromoCodeRedemption()`. Present offer-code
redemption from a stable SwiftUI view using StoreKit's native modifier (iOS/macOS):

```swift
import SwiftUI
import StoreKit
import SwiftUtilsIAP

struct PurchaseSettings: View {
    let store: IAPStore
    @State private var isRedeeming = false
    @State private var redemptionError: String?

    var body: some View {
        VStack {
            Button("Redeem offer code") {
                redemptionError = nil
                isRedeeming = true
            }
            .disabled(isRedeeming)

            if let redemptionError {
                Text(redemptionError)
            }
        }
        .offerCodeRedemption(isPresented: $isRedeeming) { result in
            if case .failure(let error) = result {
                redemptionError = error.localizedDescription
            }
        }
    }
}
```

Keep the presenting view mounted while `isRedeeming` is true; defer any automatic
paywall dismissal until the system sheet closes. The completion reports
presentation errors, not purchase success. The store receives verified redemptions
through its existing transaction listener. This modifier is unavailable on watchOS.

Catalog failures are available in `productLoadingError`; retry with
`try await store.reloadProducts()`. They do not disable transaction observation or
clear existing access. The older asynchronous `bundlePrefix:productIdentifiers:`
initializer remains available, but now exposes catalog failures through that
property instead of throwing them during initialization.

Call `await store.refreshPurchases()` when the app returns to the foreground.
This refresh does not prompt for authentication. For the user's explicit Restore
Purchases action, use `try await store.restorePurchases()` and handle errors. This
method now throws and synchronizes with the App Store before refreshing access.
Its Boolean result means that supported active purchases exist after the refresh,
not that any new purchases were restored.

Non-consumables and auto-renewable subscriptions are supported, including billing
grace periods. Non-renewing subscriptions require
`nonRenewingSubscriptionDurations: [fullProductID: durationInSeconds]` at
initialization. This policy measures access from each purchase date; it does not
stack durations or implement server-managed subscription periods.

Consumable purchases are rejected before opening StoreKit. Unsupported or
unconfigured pending transactions remain unfinished for a separate delivery
implementation; processing errors are exposed in `transactionProcessingError`.
Consumables never contribute to `hasActivePurchases`.

`Transaction.isActive` evaluates a single transaction. Supply billing-grace or
non-renewing-expiration context when using it directly; use the store's reconciled
entitlements for app access decisions.

## Utilities (WIP)
- [x]  [User Defaults manager](https://github.com/RaulPascual/SwiftUtils/blob/main/Sources/SwiftUtils/UserDefaultsManager.swift)
- [x]  [Local Notification manager](https://github.com/RaulPascual/SwiftUtils/blob/main/Sources/SwiftUtils/NotificationManager.swift)
- [x]  [Network layer](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/SwiftUtils/Network)
- [x]  [Date manager](https://github.com/RaulPascual/SwiftUtils/blob/main/Sources/SwiftUtils/DateFormatManager.swift)
- [x]  [Haptic Vibrations](https://github.com/RaulPascual/SwiftUtils/blob/main/Sources/SwiftUtils/HapticVibration.swift)
- [x]  [Temperature Unit Converter](https://github.com/RaulPascual/SwiftUtils/blob/main/Sources/SwiftUtils/TemperatureUnitConverter.swift)
- [x]  [App Coordinator](https://github.com/RaulPascual/SwiftUtils/blob/main/Sources/SwiftUtils/AppCoordinator)
- [x]  [Extensions](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/SwiftUtils/Extensions)
- [x]  [Debug view](https://github.com/RaulPascual/SwiftUtils/blob/main/Sources/SwiftUtils/DebugView)
  - [x] HTTP Request monitor
  - [x] User defaults viewer and modifier
  - [x] Push notifications viewer


## Components (WIP)

### [Checkbox](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Checkbox)
https://github.com/RaulPascual/SwiftUtils/assets/32883174/b33c610e-f933-438e-878e-ea47d31442b7

### [Sheet (semi-modal)](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/CustomSheet)
https://github.com/RaulPascual/SwiftUtils/assets/32883174/278cdde4-b2d8-4287-857d-93243afb6b15

###  [Floating button](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/FloatingButton)
https://github.com/RaulPascual/SwiftUtils/assets/32883174/f9799af7-6e2b-4416-b8c5-1632a4373db3

### [Hyperlink](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Hyperlink)
![image](https://github.com/RaulPascual/SwiftUtils/assets/32883174/a013ba1d-a24e-46ec-87e1-551c65de8d57)

### [SearchBar](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/SearchBar)
![image](https://github.com/RaulPascual/SwiftUtils/assets/32883174/63685c72-b4f5-411e-a7f2-6d211eeffccf)



- [x]  [Onboarding view](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Onboarding)
- [x]  [ImageViwer](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/ImageViwer)
- [x]  [Update app view](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/UpdateAppView)
- [x]  [ScrollTransitions](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/ScrollTransitions)
- [x]  [TextField](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/TextField)
- [x]  [Toast](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Toast)
- [x]  [Charts](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Charts)
- [x]  [Loader](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Loader)
- [x]  [Slider](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Slider)
- [x]  [SlidingTabView](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/SlidingTabView)
- [x]  [Stepper](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Stepper)
- [x]  [Tags](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Tags)
- [x]  [Extensions](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/Extensions)
- [x]  [ExperimentalFeature](https://github.com/RaulPascual/SwiftUtils/tree/main/Sources/UIComponents/ExperimentalFeature)

## Authors

- [@RaulPascual](https://www.github.com/RaulPascual)
