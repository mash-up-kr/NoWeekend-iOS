import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "HomeData",
    targets: [
        .framework(
            name: "HomeData",
            bundleId: BundleID.Home.data,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "HomeDomain", path: .relativeToRoot("Projects/Home/HomeDomain")),
                .project(target: "Core", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
