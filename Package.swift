// swift-tools-version:5.1
// We're hiding dev, test, and danger dependencies with // dev to make sure they're not fetched by users of this package.
import PackageDescription

let package = Package(
    name: "Coyote",
    products: [
        // dev .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]) // dev
    ],
    dependencies: [
        // dev .package(url: "https://github.com/danger/swift", from: "3.0.0"),
        // dev .package(path: "Submodules/WeTransfer-iOS-CI/Danger-Swift")
    ],
    targets: [
        // This is just an arbitrary Swift file in the app, that has
        // no dependencies outside of Foundation, the dependencies section
        // ensures that the library for Danger gets build also.
        // dev .target(name: "DangerDependencies", dependencies: ["Danger", "WeTransferPRLinter"], path: "Submodules/WeTransfer-iOS-CI/Danger-Swift", sources: ["DangerFakeSource.swift"])
    ]
)
