import ProjectDescription

let version = "1.2.0"
let copyright = "© LittleApps Inc. All Rights Reserved."

let buildNumber = Environment.buildNumber.getString(default: "0")

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
            "CURRENT_PROJECT_VERSION": .string(buildNumber),
            "MARKETING_VERSION": .string(version),
            "DEVELOPMENT_TEAM": .string("3Y8APYUG2G"),
            "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO"
        ]),
    targets: [
        .target(
            name: "LiveClock",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "io.ngs.LiveClock",
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            infoPlist: .extendingDefault(with: [
                "ITSAppUsesNonExemptEncryption": .boolean(false),
                "CFBundleVersion": .string("$(CURRENT_PROJECT_VERSION)"),
                "CFBundleShortVersionString": .string("$(MARKETING_VERSION)"),
                "NSHumanReadableCopyright": .string(copyright),
                "LSApplicationCategoryType": .string("public.app-category.productivity"),
                "UIViewControllerBasedStatusBarAppearance": .boolean(false),
                "UILaunchScreen": [
                    "UIColorName": "LaunchScreenBackground",
                    "UIImageRespectsSafeAreaInsets": true
                ],
                "UIStatusBarHidden": .boolean(true)
            ]),
            sources: ["Sources/App/**"],
            resources: ["Sources/Resources/**"],
            entitlements: .file(path: "Resources/LiveClock.entitlements"),
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
            name: "LiveClockTests",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .unitTests,
            bundleId: "io.ngs.LiveClockTests",
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "LiveClock"),
                .package(product: "LiveClockCore"),
                .package(product: "LiveClockUI")
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "LiveClock",
            buildAction: .buildAction(targets: ["LiveClock"]),
            testAction: .targets(
                ["LiveClockTests"],
                configuration: .debug,
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: .debug)
        )
    ]
)
