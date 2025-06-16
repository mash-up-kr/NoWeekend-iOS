import ProjectDescription

let project = Project(
    name: "Shared",
    targets: [
        .target(
            name: "Utils",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.shared.utils",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Utils/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.shared.designsystem",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DesignSystem/Sources/**"],
            resources: ["DesignSystem/Resources/**"],
            dependencies: [
                .external(name: "Lottie")
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
