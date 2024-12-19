// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YYModel",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v10_13),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "YYModel", targets: ["YYModel"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "YYModel",
            dependencies: [],
            path: "YYModel",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("../include"),
            ]
        ),
        .testTarget(name: "YYModelTests", dependencies: ["YYModel"], path: "YYModelTests")
    ],
    swiftLanguageVersions: [.v5]
)
