import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "LoginData",
    targets: [
        .framework(
            name: "LoginData",
            bundleId: BundleID.Login.data,
            sources: ["Sources/**"],
            dependencies: [
                .Login.domain,
                .Core.nwnetwork,
                .External.googleSignIn
            ]
        )
    ]
)
