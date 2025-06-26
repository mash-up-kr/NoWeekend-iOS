import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Core",
    targets: [
        // MARK: - Network Infrastructure
        .framework(
            name: "Network",
            bundleId: BundleID.Core.network,
            sources: ["Network/Sources/**"],
            dependencies: [
                .external(.alamofire),
                .project(target: "Entity", path: "../Domain"),
                .project(target: "ServiceInterface", path: "../Domain")
            ]
        )
    ]
)