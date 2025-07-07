import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Core",
    targets: [
        .framework(
            name: "DIContainer",
            bundleId: BundleID.Core.dicontainer,
            sources: ["DIContainer/Sources/**"],
            dependencies: [
                .External.swinject,
            ],
            settings: .frameworkSettings
        ),
        .framework(
            name: "NWNetwork",
            bundleId: BundleID.Core.nwnetwork,
            sources: ["NWNetwork/Sources/**"],
            dependencies: [
                .External.alamofire
            ],
            settings: .settings(
                base: Settings.frameworkSettings.base.merging([
                    "OTHER_LDFLAGS": ["-ObjC"]
                ]) { current, _ in current }
            )
        ),
        .framework(
            name: "Coordinator",
            bundleId: BundleID.Core.coordinator,
            sources: ["Coordinator/Sources/**"],
            dependencies: [
                .Core.diContainer
            ],
            settings: .frameworkSettings
        )
    ]
)
