// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpotifyAPI",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SpotifyAPI",
            targets: ["SpotifyAPI"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../REST"),
        .package(path: "../Logger"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SpotifyAPI",
            dependencies: [
                "Models",
                "REST",
                "Logger",
                .product(name: "SwiftSoup", package: "SwiftSoup"),
            ]
        ),
    ]
)
