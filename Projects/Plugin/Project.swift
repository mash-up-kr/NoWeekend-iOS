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
            ]
        ),
        .framework(
            name: "Push",
            bundleId: BundleID.Plugin.push,
            sources: ["Push/Sources/**"],
            dependencies: [
            ]
        ),
        .framework(
            name: "ThirdParty",
            bundleId: BundleID.Plugin.thirdParty,
            sources: ["ThirdParty/Sources/**"],
            dependencies: [
                .External.alamofire,
                .External.swinject,
                .External.lottie
            ]
        )
    ]
)
