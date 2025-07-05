import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "OnboardingData",
    targets: [
        .framework(
            name: "OnboardingData",
            bundleId: BundleID.Onboarding.data,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "OnboardingDomain", path: .relativeToRoot("Projects/Onboarding/OnboardingDomain")),
                .project(target: "Network", path: .relativeToRoot("Projects/Core")),
                    .project(target: "DIContainer", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
