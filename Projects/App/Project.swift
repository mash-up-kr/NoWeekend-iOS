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
                .project(target: "Feature", path: "../Feature")
            ]
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
