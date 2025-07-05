import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "ProfileFeature",
    targets: [
        .framework(
            name: "ProfileFeature",
            bundleId: BundleID.Profile.feature,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "ProfileDomain", path: .relativeToRoot("Projects/Profile/ProfileDomain")),
                .project(target: "Coordinator", path: .relativeToRoot("Projects/Core")),
                .project(target: "DIContainer", path: .relativeToRoot("Projects/Core")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
