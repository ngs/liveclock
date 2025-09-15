// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LiveClock",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        // Expose core and UI as libraries so an app target in Xcode can depend on them.
        .library(name: "LiveClockCore", targets: ["LiveClockCore"]),
        .library(name: "LiveClockPlatform", targets: ["LiveClockPlatform"]),
        .library(name: "LiveClockUI", targets: ["LiveClockUI"])
    ],
    targets: [
        .target(
            name: "LiveClockCore",
            path: "Sources/Core"
        ),
        .target(
            name: "LiveClockPlatform",
            path: "Sources/Platform"
        ),
        .target(
            name: "LiveClockUI",
            dependencies: [
                .target(name: "LiveClockCore"),
                .target(name: "LiveClockPlatform")
            ],
            path: "Sources/UI"
        ),
        // App entrypoint module. Not exposed as a product; an Xcode App target can reference these sources
        // or you can create a tiny app target that depends on the above libraries.
        .target(
            name: "LiveClockApp",
            dependencies: [
                .target(name: "LiveClockCore"),
                .target(name: "LiveClockUI"),
                .target(name: "LiveClockPlatform")
            ],
            path: "Sources/App"
        )
    ]
)

