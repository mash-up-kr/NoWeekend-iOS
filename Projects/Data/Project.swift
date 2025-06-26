import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Data",
    targets: [
        // MARK: - Repository Implementation
        .framework(
            name: "Repository",
            bundleId: Environment.bundleId(category: .core, module: "repository"),
            sources: ["Repository/Sources/**"],
            dependencies: [
                .project(target: "RepositoryInterface", path: "../Domain"),
                .project(target: "ServiceInterface", path: "../Domain"),
                .project(target: "Entity", path: "../Domain"),
                .project(target: "Network", path: "../Core"),
                .target(name: "Storage")
            ]
        ),
        
        // MARK: - Storage Implementation
        .framework(
            name: "Storage",
            bundleId: Environment.bundleId(category: .core, module: "storage"),
            sources: ["Storage/Sources/**"],
            dependencies: [
                .project(target: "Entity", path: "../Domain"),
                .project(target: "ServiceInterface", path: "../Domain")
            ]
        )
    ]
)