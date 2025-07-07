import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "LoginDomain",
    targets: [
        .framework(
            name: "LoginDomain",
            bundleId: BundleID.Login.domain,
            sources: ["Sources/**"],
            dependencies: [
                .Shared.utils
            ],
            settings: .frameworkSettings
        )
    ]
)
