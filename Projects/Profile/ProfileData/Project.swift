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
                .project(target: "Core", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
