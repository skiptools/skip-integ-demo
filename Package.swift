// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package,
// containing a Swift Package Manager project
// that will use the Skip build plugin to transpile the
// Swift Package, Sources, and Tests into an
// Android Gradle Project with Kotlin sources and JUnit tests.
import PackageDescription

let package = Package(
    name: "skip-integ-demo",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        .library(name: "SkipIntegDemo", type: .dynamic, targets: ["SkipIntegDemo"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.1.24"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-fuse.git", "0.0.0"..<"2.0.0"),
        .package(url: "https://source.skip.tools/skip-bridge.git", "0.0.0"..<"2.0.0"),
    ],
    targets: [
        .target(name: "SkipIntegDemo", dependencies: [
            .product(name: "SkipFoundation", package: "skip-foundation"),
            .product(name: "SkipFuse", package: "skip-fuse"),
            .product(name: "SkipBridge", package: "skip-bridge"),
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipIntegDemoTests", dependencies: [
            "SkipIntegDemo",
            .product(name: "SkipTest", package: "skip")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
