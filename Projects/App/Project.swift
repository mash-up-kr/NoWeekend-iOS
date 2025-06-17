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
                .feature(.onboarding)
            ]
        )
    ]
)
