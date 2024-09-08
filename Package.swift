// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WordleGame",
    platforms: [
        .iOS(.v13)  // Зависимости для iOS 11 и выше
    ],
    products: [
        .library(
            name: "WordleGame",
            targets: ["WordleGame"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WordleGame",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "WordleGameTests",
            dependencies: ["WordleGame"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
