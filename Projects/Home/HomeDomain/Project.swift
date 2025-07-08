import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "HomeDomain",
    targets: [
        .framework(
            name: "HomeDomain",
            bundleId: BundleID.Home.domain,
            sources: ["Sources/**"],
            dependencies: [
            ],
            settings: .frameworkSettings
        )
    ]
)
