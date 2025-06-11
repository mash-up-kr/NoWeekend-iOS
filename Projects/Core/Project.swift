import ProjectDescription

let project = Project(
    name: "Core",
    targets: [
        .target(
            name: "UseCase",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.core.usecase",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["UseCase/Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Interface"),
                .project(target: "RepositoryInterface", path: "../Interface"),
                .project(target: "ServiceInterface", path: "../Interface")
            ]
        ),
        .target(
            name: "Repository",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.core.repository",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Repository/Sources/**"],
            dependencies: [
                .project(target: "RepositoryInterface", path: "../Interface"),
                .project(target: "Domain", path: "../Interface"),
                .project(target: "NetworkInterface", path: "../Interface"),
                .project(target: "StorageInterface", path: "../Interface")
            ]
        ),
        .target(
            name: "Network",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.core.network",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Network/Sources/**"],
            dependencies: [
                .project(target: "NetworkInterface", path: "../Interface"),
                .external(name: "Alamofire")
            ]
        ),
        .target(
            name: "Storage",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.core.storage",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Storage/Sources/**"],
            dependencies: [
                .project(target: "StorageInterface", path: "../Interface"),
                .project(target: "Domain", path: "../Interface")
            ]
        )
    ]
)
