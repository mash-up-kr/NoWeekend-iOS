import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "HomeFeature",
    targets: [
        .framework(
            name: "HomeFeature",
            bundleId: BundleID.Home.feature,
            sources: ["Sources/**"],
            dependencies: [
                .Home.domain,
                .Core.diContainer,
                .Core.coordinator,
                .Shared.designSystem,
                .Shared.utils
            ],
            settings: .frameworkSettings
        )
    ]
)
