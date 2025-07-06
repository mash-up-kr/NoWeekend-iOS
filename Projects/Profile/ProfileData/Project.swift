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
                .Profile.domain,
                .Core.nwnetwork,
                .Core.diContainer
            ]
        )
    ]
)
