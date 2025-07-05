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
                .project(target: "Core", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
