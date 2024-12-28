// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SubscriptionFeature",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SubscriptionFeature",
            targets: [
                "SubscriptionFeature",
            ]
        ),
        .library(
            name: "SubscriptionDomain",
            targets: [
                "SubscriptionDomain",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Logger"),
        .package(url: "https://github.com/RevenueCat/purchases-ios-spm", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SubscriptionFeature",
            dependencies: [
                "SubscriptionDomain",
                "Logger",
            ]
        ),
        .target(
            name: "SubscriptionDomain",
            dependencies: [
                .product(name: "RevenueCat", package: "purchases-ios-spm"),
            ]
        ),
        .testTarget(
            name: "SubscriptionFeatureTests",
            dependencies: ["SubscriptionFeature"]
        ),
    ]
)
