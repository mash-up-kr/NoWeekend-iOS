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
                .Profile.domain,
                .Core.coordinator,
                .Core.diContainer,
                .Shared.designSystem,
                .Shared.utils
            ]
        )
    ]
)
