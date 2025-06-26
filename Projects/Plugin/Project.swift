import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: "Plugin",
    targets: [
        .framework(
            name: "Analytics",
            bundleId: BundleID.Plugin.analytics,
            sources: ["Analytics/Sources/**"],
            dependencies: [
                .domain(.serviceInterface)
            ]
        ),
        .framework(
            name: "Push",
            bundleId: BundleID.Plugin.push,
            sources: ["Push/Sources/**"],
            dependencies: [
                .domain(.serviceInterface)
            ]
        ),
        .framework(
            name: "ThirdParty",
            bundleId: BundleID.Plugin.thirdParty,
            sources: ["ThirdParty/Sources/**"]
        )
    ]
)
