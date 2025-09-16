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
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": .string("LiveClock"),
                "CFBundleIconFile": .string("AppIcon"),
                "CFBundleName": .string("LiveClock"),
                "UIStatusBarHidden": .boolean(true),
                "UIViewControllerBasedStatusBarAppearance": .boolean(false),
                "UILaunchStoryboardName": .string(""),
                "UIRequiresFullScreen": .boolean(true)
            ]),
            sources: ["Sources/App/**"],
            resources: ["Sources/Resources/**"],
            dependencies: [
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockPlatform"),
                .package(product: "LiveClockUI")
            ]
        ),
        .target(
            name: "LiveClock-macOS",
            destinations: [.mac],
            product: .app,
            bundleId: "io.ngs.LiveClock.mac",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": .string("LiveClock"),
                "CFBundleName": .string("LiveClock"),
                "CFBundleIconFile": .string("AppIcon"),
            ]),
            sources: ["Sources/App/**"],
            resources: ["Sources/Resources/**"],
            dependencies: [
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockPlatform"),
                .package(product: "LiveClockUI")
            ]
        ),
        .target(
            name: "LiveClock-visionOS",
            destinations: [.appleVision],
            product: .app,
            bundleId: "io.ngs.LiveClock.vision",
            deploymentTargets: .visionOS("1.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleIconFile": .string("AppIcon"),
                "CFBundleDisplayName": .string("LiveClock"),
                "CFBundleName": .string("LiveClock")
            ]),
            sources: ["Sources/App/**"],
            resources: ["Sources/Resources/**"],
            dependencies: [
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockPlatform"),
                .package(product: "LiveClockUI")
            ]
        )
    ]
)
