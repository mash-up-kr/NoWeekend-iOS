import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "DataBridge",
    targets: [
        .framework(
            name: "DataBridge",
            bundleId: "com.noweekend.databridge",
            sources: ["Sources/**"],
            dependencies: [
                .Home.data,
                .Profile.data,
                .Calendar.data,
                .Onboarding.data,
                .Login.data,
                .Core.diContainer
            ],
            settings: .frameworkSettings
        )
    ]
)
