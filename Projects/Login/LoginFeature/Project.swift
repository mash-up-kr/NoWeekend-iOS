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
                .Core.coordinator,
                .Core.diContainer,
                .Shared.designSystem,
                .Shared.utils
            ]
        )
    ]
)
