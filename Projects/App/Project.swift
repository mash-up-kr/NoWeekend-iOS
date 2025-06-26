import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "App",
    targets: [
        .app(
            name: "App",
            bundleId: Environment.App.baseBundleId,
            infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
            dependencies: [
                // Feature 모듈들
                .feature(.home),
                .feature(.profile),
                .feature(.calendar),
                .feature(.onboarding),
                
                // Core 모듈들 (실제 존재하는 것만)
                .core(.network),
                
                // Domain 모듈들
                .domain(.entity),
                .domain(.repositoryInterface),
                .domain(.serviceInterface),
                .domain(.useCase),
                
                // Data 모듈들
                .data(.repository),
                .data(.storage),
                
                // Shared 모듈들
                .shared(.designSystem),
                .shared(.utils)
            ]
        )
    ]
)
