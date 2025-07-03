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
                .project(target: "Core", path: .relativeToRoot("Projects/Core")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
                // ProfileData 의존성 완전 제거!
            ]
        )
    ]
)
