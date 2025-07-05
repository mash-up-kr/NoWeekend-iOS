import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Core",
    targets: [
        .framework(
            name: "DIContainer",
            bundleId: BundleID.Core.dicontainer,
            sources: ["DIContainer/Sources/**"],
            dependencies: [
                .external(.swinject)
            ]
        ),
        .framework(
            name: "Network",
            bundleId: BundleID.Core.network + ".network",
            sources: ["Network/Sources/**"],
            dependencies: [
                .external(.alamofire),
                .external(.swinject),
                .core(.diContainer)
            ]
        ),
        .framework(
            name: "Coordinator",
            bundleId: BundleID.Core.coordinator,
            sources: ["Coordinator/Sources/**"],
            dependencies: [
                .external(.swinject),
                .core(.diContainer)
            ]
        )
    ]
)
