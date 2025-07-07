import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Shared",
    targets: [
        .framework(
            name: "Utils",
            bundleId: BundleID.Shared.utils,
            sources: ["Utils/Sources/**"],
            dependencies: [
                .Core.diContainer,
                .External.swinject
            ]
        ),
        .framework(
            name: "DesignSystem",
            bundleId: BundleID.Shared.designSystem,
            sources: ["DesignSystem/Sources/**"],
            resources: ["DesignSystem/Resources/**"],
            dependencies: [
                .External.lottie
            ]
        )
    ],
    resourceSynthesizers: [
        .custom(
            name: "Assets",
            parser: .assets,
            extensions: ["xcassets"]
        ),
        .custom(
            name: "Fonts",
            parser: .fonts,
            extensions: ["ttf"]
        ),
        .custom(
            name: "JSON",
            parser: .json,
            extensions: ["json"]
        )
    ]
)
