import ProjectDescription

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.noweekend.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
            sources: ["Sources/**"],
            resources: [
                "Resources/**"
            ],
            dependencies: [
                .project(target: "Presentation", path: "../Presentation"),
                .project(target: "Common", path: "../Core"),
                .project(target: "Data", path: "../Core"),
                .project(target: "Domain", path: "../Core"),
                .project(target: "TabBar", path: "../Features"),
                .project(target: "DesignSystem", path: "../UI"),
            ],
            settings: .settings(
                base: [
                    "CODE_SIGN_STYLE": "Manual",
                    "DEVELOPMENT_TEAM": "SQ5T25W9V5"
                ],
                configurations: [
                    .debug(
                        name: .debug,
                        settings: [
                            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.noweekend.app",
                            "CODE_SIGN_IDENTITY": "Apple Development"
                        ],
                        xcconfig: nil
                    ),
                    .release(
                        name: .release,
                        settings: [
                            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.noweekend.app",
                            "CODE_SIGN_IDENTITY": "Apple Distribution"
                        ],
                        xcconfig: nil
                    )
                ]
            )
        )
    ],
    schemes: [
        .scheme(
            name: "App",
            shared: true,
            buildAction: .buildAction(targets: ["App"]),
            testAction: TestAction.targets([]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release)
        )
    ]
)
