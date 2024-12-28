// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnalyticsFeature",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AnalyticsFeature",
            targets: [
                "AnalyticsFeature",
            ]
        ),
        .library(
            name: "AnalyticsDomain",
            targets: [
                "AnalyticsDomain",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Logger"),
        .package(path: "../Fundamentals"),
        .package(path: "../Permission"),
        .package(url: "https://github.com/TelemetryDeck/SwiftSDK.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AnalyticsFeature",
            dependencies: [
                "AnalyticsDomain",
                "Logger",
                "Fundamentals",
                "Permission",
            ]
        ),
        .target(
            name: "AnalyticsDomain",
            dependencies: [
                .product(name: "TelemetryDeck", package: "swiftsdk"),
            ]
        ),
        .testTarget(
            name: "AnalyticsFeatureTests",
            dependencies: ["AnalyticsFeature"]
        ),
    ]
)
