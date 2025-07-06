import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "HomeData",
    targets: [
        .framework(
            name: "HomeData",
            bundleId: BundleID.Home.data,
            sources: ["Sources/**"],
            dependencies: [
                .Home.domain,
                .Core.diContainer
            ]
        )
    ]
)
