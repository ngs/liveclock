// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LiveClock",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .visionOS(.v2),
    ],
    products: [
        // Expose core and UI as libraries so an app target in Xcode can depend on them.
        .library(name: "LiveClockCore", targets: ["LiveClockCore"]),
        .library(name: "LiveClockPlatform", targets: ["LiveClockPlatform"]),
        .library(name: "LiveClockUI", targets: ["LiveClockUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.0")
    ],
    targets: [
        .target(
            name: "LiveClockCore",
            path: "Sources/Core",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .swiftLanguageMode(.v6)
            ]
        ),
        .target(
            name: "LiveClockPlatform",
            path: "Sources/Platform",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .swiftLanguageMode(.v6)
            ]
        ),
        .target(
            name: "LiveClockUI",
            dependencies: [
                .target(name: "LiveClockCore"),
                .target(name: "LiveClockPlatform"),
            ],
            path: "Sources/UI",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "LiveClockCoreTests",
            dependencies: ["LiveClockCore"],
            path: "Tests/LiveClockCoreTests"
        ),
        .testTarget(
            name: "LiveClockUITests",
            dependencies: ["LiveClockUI", "LiveClockCore"],
            path: "Tests/LiveClockUITests"
        ),
    ]
)
