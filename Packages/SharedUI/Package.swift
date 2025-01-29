// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/EmergeTools/Pow", from: Version(1, 0, 0)),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SharedUI",
            dependencies: [
                .product(name: "Pow", package: "Pow"),
            ]
        ),
    ]
)
