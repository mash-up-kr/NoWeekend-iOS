import ProjectDescription

let project = Project(
    name: "Shared",
    targets: [
        .target(
            name: "Common",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.shared.common",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Common/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.shared.designsystem",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DesignSystem/Sources/**"],
            resources: ["DesignSystem/Resources/**"],
            dependencies: [
                .target(name: "Common")
            ]
        ),
        .target(
            name: "Resources",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.shared.resources",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Resources/Sources/**"],
            resources: ["Resources/Resources/**"],
            dependencies: [
                .target(name: "Common")
            ]
        )
    ]
)
