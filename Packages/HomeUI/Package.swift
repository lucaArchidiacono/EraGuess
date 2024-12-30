// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HomeUI",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HomeUI",
            targets: ["HomeUI"]
        ),
    ],
    dependencies: [
        .package(path: "../AnalyticsFeature"),
        .package(path: "../Models"),
        .package(path: "../StateFeature"),
        .package(path: "../UINavigation"),
        .package(path: "../Services"),
        .package(path: "../HapticFeedbackFeature"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HomeUI",
            dependencies: [
                "AnalyticsFeature",
                "Models",
                "StateFeature",
                "UINavigation",
                "HapticFeedbackFeature",
                "Services",
            ]
        ),
    ]
)
