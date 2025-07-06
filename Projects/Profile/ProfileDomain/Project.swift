import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "ProfileDomain",
    targets: [
        .framework(
            name: "ProfileDomain",
            bundleId: BundleID.Profile.domain,
            sources: ["Sources/**"],
            dependencies: [
            ]
        )
    ]
)
