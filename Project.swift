import ProjectDescription

let project = Project(
    name: "MOEUM",
    organizationName: "MOEUM",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.0",
            "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
            "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
            "SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY": "YES",
        ]
    ),
    targets: [
        .target(
            name: "MOEUM",
            destinations: .iOS,
            product: .app,
            bundleId: "aa.MOEUM",
            deploymentTargets: .iOS("26.5"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [:],
                    "UIApplicationSupportsIndirectInputEvents": true,
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight",
                    ],
                    "UISupportedInterfaceOrientations~ipad": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationPortraitUpsideDown",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight",
                    ],
                ]
            ),
            sources: ["MOEUM/**/*.swift"],
            resources: ["MOEUM/Assets.xcassets"],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "CURRENT_PROJECT_VERSION": "1",
                    "MARKETING_VERSION": "1.0",
                ]
            )
        ),
    ],
    schemes: [
        .scheme(
            name: "MOEUM",
            shared: true,
            buildAction: .buildAction(targets: ["MOEUM"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
    ]
)
