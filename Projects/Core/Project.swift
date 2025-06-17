import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: "Core",
    targets: [
        .framework(
            name: "UseCase",
            bundleId: BundleID.Core.useCase,
            sources: ["UseCase/Sources/**"],
            dependencies: [
                .interface(.domain),
                .interface(.repositoryInterface),
                .interface(.serviceInterface)
            ]
        ),
        .framework(
            name: "Repository",
            bundleId: BundleID.Core.repository,
            sources: ["Repository/Sources/**"],
            dependencies: [
                .interface(.repositoryInterface),
                .interface(.domain),
                .interface(.networkInterface),
                .interface(.storageInterface)
            ]
        ),
        .framework(
            name: "Network",
            bundleId: BundleID.Core.network,
            sources: ["Network/Sources/**"],
            dependencies: [
                .interface(.networkInterface),
                .external(.alamofire)
            ]
        ),
        .framework(
            name: "Storage",
            bundleId: BundleID.Core.storage,
            sources: ["Storage/Sources/**"],
            dependencies: [
                .interface(.storageInterface),
                .interface(.domain)
            ]
        )
    ]
)
