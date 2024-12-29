// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameUI",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GameUI",
            targets: ["GameUI"]
        ),
    ],
    dependencies: [
        .package(path: "../AnalyticsFeature"),
        .package(path: "../Models"),
        .package(path: "../StateFeature"),
        .package(path: "../UINavigation"),
        .package(path: "../HapticFeedbackFeature"),
        .package(path: "../Services"),
        .package(path: "../Logger"),
        .package(path: "../EraGuessUI"),
        .package(path: "../SharedUI"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI.git", branch: "master"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GameUI",
            dependencies: [
                "AnalyticsFeature",
                "Models",
                "StateFeature",
                "UINavigation",
                "HapticFeedbackFeature",
                "Services",
                "Logger",
                "EraGuessUI",
                "SharedUI",
                .product(name: "ConfettiSwiftUI", package: "ConfettiSwiftUI"),
            ]
        ),
    ]
)
