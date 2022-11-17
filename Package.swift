// swift-tools-version:5.5
// We're hiding dev, test, and danger dependencies with // dev to make sure they're not fetched by users of this package.
import PackageDescription

let package = Package(
    name: "WeScan",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "WeScan", type: .static, targets: ["WeScan"])
    ],
    targets: [
        .target(name: "WeScan",
                path: "WeScan",
                exclude: [
                    "Info.plist",
                    "WeScan.h"
                ],
                resources: [
                    .process("Resources")
                ])
    ]
)
