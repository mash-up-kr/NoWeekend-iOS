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
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "TabBar", path: "../Feature"),
                .project(target: "Home", path: "../Feature"),
                .project(target: "Profile", path: "../Feature"),
                .project(target: "Calendar", path: "../Feature"),
                .project(target: "Onboarding", path: "../Feature"),
                .project(target: "UseCase", path: "../Core"),
                .project(target: "Repository", path: "../Core"),
                .project(target: "Network", path: "../Core"),
                .project(target: "Storage", path: "../Core"),
                .project(target: "DesignSystem", path: "../Shared"),
                .project(target: "Common", path: "../Shared")
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
                        ]
                    ),
                    .release(
                        name: .release,
                        settings: [
                            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.noweekend.app",
                            "CODE_SIGN_IDENTITY": "Apple Distribution"
                        ]
                    )
                ]
            )
        )
    ]
)
