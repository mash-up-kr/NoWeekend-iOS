import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Domain",
    targets: [
        // MARK: - Pure Domain Models
        .framework(
            name: "Entity",
            bundleId: BundleID.Domain.entity,
            sources: ["Entity/Sources/**"],
            dependencies: [] // 아무것도 의존하지 않음
        ),
        
        // MARK: - Repository Interface
        .framework(
            name: "RepositoryInterface",
            bundleId: BundleID.Domain.repositoryInterface,
            sources: ["RepositoryInterface/Sources/**"],
            dependencies: [
                .target(name: "Entity")
            ]
        ),
        
        // MARK: - Service Interface
        .framework(
            name: "ServiceInterface",
            bundleId: BundleID.Domain.serviceInterface,
            sources: ["ServiceInterface/Sources/**"],
            dependencies: [
                .target(name: "Entity")
            ]
        ),
        
        // MARK: - Business Logic
        .framework(
            name: "UseCase",
            bundleId: BundleID.Domain.useCase,
            sources: ["UseCase/Sources/**"],
            dependencies: [
                .target(name: "Entity"),
                .target(name: "RepositoryInterface") // Interface만 의존
            ]
        )
    ]
)