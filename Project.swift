import ProjectDescription

let project = Project(
    name: "NoWeekend",
    targets: [
        .target(
            name: "NoWeekend",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.NoWeekend",
            infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
            sources: ["NoWeekend/Sources/**"],
            resources: ["NoWeekend/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "NoWeekendTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NoWeekendTests",
            infoPlist: .default,
            sources: ["NoWeekend/Tests/**"],
            resources: [],
            dependencies: [.target(name: "NoWeekend")]
        ),
    ]
)
