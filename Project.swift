import ProjectDescription

let project = Project(
    name: "LiveClock",
    packages: [
        .package(path: ".")
    ],
    targets: [
        .target(
            name: "LiveClock-iOS",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "io.ngs.LiveClock",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/App/**"],
            resources: [],
            dependencies: [
                .product(name: "LiveClockCore", package: "LiveClock"),
                .product(name: "LiveClockPlatform", package: "LiveClock"),
                .product(name: "LiveClockUI", package: "LiveClock")
            ]
        ),
        .target(
            name: "LiveClock-macOS",
            destinations: [.mac],
            product: .app,
            bundleId: "io.ngs.LiveClock.mac",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/App/**"],
            resources: [],
            dependencies: [
                .product(name: "LiveClockCore", package: "LiveClock"),
                .product(name: "LiveClockPlatform", package: "LiveClock"),
                .product(name: "LiveClockUI", package: "LiveClock")
            ]
        ),
        .target(
            name: "LiveClock-tvOS",
            destinations: [.tv],
            product: .app,
            bundleId: "io.ngs.LiveClock.tv",
            deploymentTargets: .tvOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/App/**"],
            resources: [],
            dependencies: [
                .product(name: "LiveClockCore", package: "LiveClock"),
                .product(name: "LiveClockPlatform", package: "LiveClock"),
                .product(name: "LiveClockUI", package: "LiveClock")
            ]
        )
        // visionOS target (requires a recent Tuist with .visionOS support)
        // .target(
        //     name: "LiveClock-visionOS",
        //     destinations: [.vision],
        //     product: .app,
        //     bundleId: "io.ngs.LiveClock.vision",
        //     deploymentTargets: .visionOS("1.0"),
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
