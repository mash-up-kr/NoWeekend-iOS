import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "LoginFeature",
    targets: [
        .framework(
            name: "LoginFeature",
            bundleId: BundleID.Login.feature,
            sources: ["Sources/**"],
            dependencies: [
                .Login.domain,
                .Login.data,
                .Core.coordinator,
                .Core.diContainer,
                .Core.nwnetwork,
                .Shared.designSystem,
                .Shared.utils
            ]
        )
    ]
)
