import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "ProfileData",
    targets: [
        .framework(
            name: "ProfileData",
            bundleId: BundleID.Profile.data,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "ProfileDomain", path: .relativeToRoot("Projects/Profile/ProfileDomain")),
                .project(target: "Network", path: .relativeToRoot("Projects/Core")),
                .project(target: "DIContainer", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
