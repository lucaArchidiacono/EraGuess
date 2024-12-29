// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SettingsUI",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SettingsUI",
            targets: ["SettingsUI"]
        ),
    ],
    dependencies: [
        .package(path: "../AnalyticsFeature"),
        .package(path: "../Models"),
        .package(path: "../StateFeature"),
        .package(path: "../UINavigation"),
        .package(path: "../EraGuessUI"),
        .package(path: "../EraGuessShared"),
        .package(path: "../SharedUI"),
        .package(path: "../Permission"),
        .package(path: "../EmailFeatureUI"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SettingsUI",
            dependencies: [
                "AnalyticsFeature",
                "Models",
                "StateFeature",
                "UINavigation",
                "EraGuessUI",
                "EraGuessShared",
                "SharedUI",
                "Permission",
                "EmailFeatureUI",
            ]
        ),
    ]
)
