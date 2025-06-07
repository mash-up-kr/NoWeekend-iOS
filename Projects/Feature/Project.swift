import ProjectDescription
import ProjectDescriptionHelpers


let project = Project(
    name: "Feature",
    packages: [
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0")
    ],
    targets: [
        .target(
            name: "Feature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.feature",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external( .googleSignIn),
                .external(.alamofire)
            ]
        )
    ]
)
