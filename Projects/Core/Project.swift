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
            ]
        ),
        .framework(
            name: "NWNetwork",
            bundleId: BundleID.Core.nwnetwork,
            sources: ["NWNetwork/Sources/**"],
            dependencies: [
                .External.alamofire,
                .Core.diContainer,
                .External.googleSignIn
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": ["-ObjC"]
                ]
            )
        ),
        .framework(
            name: "Coordinator",
            bundleId: BundleID.Core.coordinator,
            sources: ["Coordinator/Sources/**"],
            dependencies: [
                .Core.diContainer
            ]
        )
    ]
)
