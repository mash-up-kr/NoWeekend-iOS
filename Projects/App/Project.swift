import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "App",
    targets: [
        .app(
            name: "App",
            bundleId: BundleID.app,
            infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .Home.feature,
                .Profile.feature,
                .Calendar.feature,
                .Onboarding.feature,
                .Login.feature,
                .Bridge.dataBridge,
                .Shared.designSystem,
                .Shared.utils
            ],
            settings: .appSettings(teamID: Environment.teamID)
        )
    ],
    resourceSynthesizers: [
        .custom(
            name: "Fonts",
            parser: .fonts,
            extensions: ["ttf", "otf"]
        ),
        .custom(
            name: "Strings",
            parser: .strings,
            extensions: ["strings"]
        )
    ]
)
