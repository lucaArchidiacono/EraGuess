// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HapticFeedbackFeature",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HapticFeedbackFeature",
            targets: ["HapticFeedbackFeature"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HapticFeedbackFeature",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "HapticFeedbackFeatureTests",
            dependencies: ["HapticFeedbackFeature"]
        ),
    ]
)
