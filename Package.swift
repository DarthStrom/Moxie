// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Moxie",
    products: [
        .library(
            name: "Moxie",
            targets: ["Moxie"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Moxie",
            dependencies: []),
        .testTarget(
            name: "MoxieTests",
            dependencies: ["Moxie"]),
    ]
)
