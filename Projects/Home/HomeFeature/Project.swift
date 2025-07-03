import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "HomeFeature",
    targets: [
        .framework(
            name: "HomeFeature",
            bundleId: BundleID.Home.feature,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "HomeDomain", path: .relativeToRoot("Projects/Home/HomeDomain")),
                .project(target: "Core", path: .relativeToRoot("Projects/Core")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
