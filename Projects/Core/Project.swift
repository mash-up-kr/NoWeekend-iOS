import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Core",
    targets: [
        // MARK: - Core (Network + DI + Coordinator)
        .framework(
            name: "Core",
            bundleId: BundleID.Core.network,
            sources: ["Sources/**"],
            dependencies: [
                .external(.alamofire),
                .external(.swinject)
            ]
        )
    ]
)
