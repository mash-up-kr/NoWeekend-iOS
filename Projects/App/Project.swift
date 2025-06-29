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
                .feature(.tabBar),
                .feature(.onboarding),
                .feature(.login),
                // DIContainer에서 필요한 의존성들
                .core(.useCase),
                .core(.repository),
                .core(.network),
                // 외부 의존성
                .external(.alamofire)
            ]
        )
    ]
)
