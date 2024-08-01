// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUtilsPackage",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUtilsLibrary", targets: ["SwiftUtilities"]),
        .library(
            name: "UIComponentsLibrary", targets: ["UIComponents"]),
    ],
    dependencies: [
             .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0")
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "SwiftUtilities", path: "Sources/SwiftUtils"),
        .target(name: "UIComponents", path: "Sources/UIComponents"),
        .testTarget(
            name: "SwiftUtilsTests",
            dependencies: ["SwiftUtilities",
                           .product(name: "SnapshotTesting", package: "swift-snapshot-testing")]),
        .testTarget(
            name: "UIComponentsSnapshotTests",
            dependencies: ["UIComponents",
                           .product(name: "SnapshotTesting", package: "swift-snapshot-testing")],
            exclude: [
                "__Snapshots__"
            ]),
    ]
)
