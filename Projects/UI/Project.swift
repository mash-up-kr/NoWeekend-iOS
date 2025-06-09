import ProjectDescription

let project = Project(
    name: "UI",
    targets: [
        // DesignSystem 타겟
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.designsystem",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DesignSystem/Sources/**"],
            resources: ["DesignSystem/Resources/**"],
            dependencies: [
                .project(target: "Common", path: "../Core"),
                .project(target: "Util", path: "../Core"),
                .project(target: "Presentation", path: "../Presentation")
            ]
        )
    ]
)
