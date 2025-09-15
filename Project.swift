import ProjectDescription

let project = Project(
    name: "LiveClock",
    packages: [
        .package(path: ".")
    ],
    targets: [
        Target(
            name: "LiveClock-iOS",
            platform: .iOS,
            product: .app,
            bundleId: "io.ngs.LiveClock",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["Sources/App/**"],
            resources: [],
            dependencies: [
                .product(name: "LiveClockCore", package: "LiveClock"),
                .product(name: "LiveClockPlatform", package: "LiveClock"),
                .product(name: "LiveClockUI", package: "LiveClock")
            ]
        ),
        Target(
            name: "LiveClock-macOS",
            platform: .macOS,
            product: .app,
            bundleId: "io.ngs.LiveClock.mac",
            deploymentTarget: .macOS(targetVersion: "13.0"),
            infoPlist: .default,
            sources: ["Sources/App/**"],
            resources: [],
            dependencies: [
                .product(name: "LiveClockCore", package: "LiveClock"),
                .product(name: "LiveClockPlatform", package: "LiveClock"),
                .product(name: "LiveClockUI", package: "LiveClock")
            ]
        ),
        Target(
            name: "LiveClock-tvOS",
            platform: .tvOS,
            product: .app,
            bundleId: "io.ngs.LiveClock.tv",
            deploymentTarget: .tvOS(targetVersion: "16.0"),
            infoPlist: .default,
            sources: ["Sources/App/**"],
            resources: [],
            dependencies: [
                .product(name: "LiveClockCore", package: "LiveClock"),
                .product(name: "LiveClockPlatform", package: "LiveClock"),
                .product(name: "LiveClockUI", package: "LiveClock")
            ]
        )
        // visionOS target is possible with newer Tuist versions:
        // Target(
        //     name: "LiveClock-visionOS",
        //     platform: .visionOS,
        //     product: .app,
        //     bundleId: "io.ngs.LiveClock.vision",
        //     deploymentTarget: .visionOS(targetVersion: "1.0"),
        //     infoPlist: .default,
        //     sources: ["Sources/App/**"],
        //     resources: [],
        //     dependencies: [
        //         .product(name: "LiveClockCore", package: "LiveClock"),
        //         .product(name: "LiveClockPlatform", package: "LiveClock"),
        //         .product(name: "LiveClockUI", package: "LiveClock")
        //     ]
        // )
    ]
)

