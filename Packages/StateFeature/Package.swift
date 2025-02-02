// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StateFeature",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "StateFeature",
            targets: ["StateFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(url: "https://github.com/pointfreeco/swift-sharing", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "StateFeature",
            dependencies: [
                "Models",
                .product(name: "Sharing", package: "swift-sharing"),
            ]
        ),
    ]
)
