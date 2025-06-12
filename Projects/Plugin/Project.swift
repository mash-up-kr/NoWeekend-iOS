import ProjectDescription

let project = Project(
    name: "Plugin",
    targets: [
        .target(
            name: "Analytics",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.plugin.analytics",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Analytics/Sources/**"],
            dependencies: [
                .project(target: "ServiceInterface", path: "../Interface")
            ]
        ),
        .target(
            name: "Push",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.plugin.push",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Push/Sources/**"],
            dependencies: [
                .project(target: "ServiceInterface", path: "../Interface")
            ]
        ),
        .target(
            name: "ThirdParty",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.plugin.thirdparty",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["ThirdParty/Sources/**"],
            dependencies: []
        )
    ]
)
