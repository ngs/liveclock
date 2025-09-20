import ProjectDescription

let version = "1.0.0"
let copyright = "© LittleApps Inc. All Rights Reserved."

let actionRunId = Environment.runId.getString(default: "0")

let project = Project(
    name: "LiveClock",
    organizationName: "LittleApps Inc.",
    packages: [
        .package(path: ".")
    ],
    settings: .settings(
        base: [
            "INFOPLIST_KEY_LSApplicationCategoryType": .string("public.app-category.productivity"),
            "INFOPLIST_KEY_CFBundleIconFile": .string("AppIcon"),
            "INFOPLIST_KEY_CFBundleDisplayName": .string("LiveClock"),
            "INFOPLIST_KEY_CFBundleName": .string("LiveClock"),
            "CURRENT_PROJECT_VERSION": .string(actionRunId),
            "MARKETING_VERSION": .string(version),
            "DEVELOPMENT_TEAM": .string("3Y8APYUG2G")
        ]),
    targets: [
        .target(
            name: "LiveClock-iOS",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "io.ngs.LiveClock",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(with: [
                "UIViewControllerBasedStatusBarAppearance": .boolean(false),
                "UILaunchStoryboardName": .string(""),
                "UIStatusBarHidden": .boolean(true),
                "CFBundleDisplayName": .string("LiveClock"),
                "CFBundleName": .string("LiveClock"),
                "CFBundleVersion": .string("$(CURRENT_PROJECT_VERSION)"),
                "CFBundleShortVersionString": .string("$(MARKETING_VERSION)"),
                "ITSAppUsesNonExemptEncryption": .boolean(false)
            ]),
            sources: ["Sources/App/**"],
            resources: ["Sources/Resources/**"],
            scripts: [
                .pre(
                    script: "${SRCROOT}/Scripts/swiftlint-fix-build-phase.sh",
                    name: "SwiftLint Auto-Fix",
                    basedOnDependencyAnalysis: false
                )
            ],
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
            bundleId: "io.ngs.LiveClock",
            deploymentTargets: .macOS("15.0"),
            infoPlist: .extendingDefault(with: [
                "ITSAppUsesNonExemptEncryption": .boolean(false),
                "NSHumanReadableCopyright": .string(copyright),
                "LSApplicationCategoryType": .string("public.app-category.productivity"),
                "CFBundleVersion": .string("$(CURRENT_PROJECT_VERSION)"),
                "CFBundleShortVersionString": .string("$(MARKETING_VERSION)")
            ]),
            sources: ["Sources/App/**"],
            resources: ["Sources/Resources/**"],
            entitlements: .file(path: "Resources/LiveClock-macOS.entitlements"),
            scripts: [
                .pre(
                    script: "${SRCROOT}/Scripts/swiftlint-fix-build-phase.sh",
                    name: "SwiftLint Auto-Fix",
                    basedOnDependencyAnalysis: false
                )
            ],
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
            bundleId: "io.ngs.LiveClock",
            deploymentTargets: .visionOS("2.0"),
            infoPlist: .extendingDefault(with: [
                "ITSAppUsesNonExemptEncryption": .boolean(false),
                "CFBundleVersion": .string("$(CURRENT_PROJECT_VERSION)"),
                "CFBundleShortVersionString": .string("$(MARKETING_VERSION)")
            ]),
            sources: ["Sources/App/**"],
            resources: ["Sources/Resources/**"],
            scripts: [
                .pre(
                    script: "${SRCROOT}/Scripts/swiftlint-fix-build-phase.sh",
                    name: "SwiftLint Auto-Fix",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockPlatform"),
                .package(product: "LiveClockUI")
            ]
        ),
        .target(
            name: "LiveClockTests-iOS",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "io.ngs.LiveClockTests",
            deploymentTargets: .iOS("18.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "LiveClock-iOS"),
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockUI")
            ]
        ),
        .target(
            name: "LiveClockTests-macOS",
            destinations: [.mac],
            product: .unitTests,
            bundleId: "io.ngs.LiveClockTests",
            deploymentTargets: .macOS("14.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "LiveClock-macOS"),
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockUI")
            ]
        ),
        .target(
            name: "LiveClockTests-visionOS",
            destinations: [.appleVision],
            product: .unitTests,
            bundleId: "io.ngs.LiveClockTests",
            deploymentTargets: .visionOS("1.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "LiveClock-visionOS"),
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockUI")
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "LiveClock-iOS",
            buildAction: .buildAction(targets: ["LiveClock-iOS"]),
            testAction: .targets(
                ["LiveClockTests-iOS"],
                configuration: .debug,
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "LiveClock-macOS",
            buildAction: .buildAction(targets: ["LiveClock-macOS"]),
            testAction: .targets(
                ["LiveClockTests-macOS"],
                configuration: .debug,
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "LiveClock-visionOS",
            buildAction: .buildAction(targets: ["LiveClock-visionOS"]),
            testAction: .targets(
                ["LiveClockTests-visionOS"],
                configuration: .debug,
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: .debug)
        )
    ]
)
