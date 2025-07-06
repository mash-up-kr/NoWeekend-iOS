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
                .Onboarding.domain,
                .Core.diContainer
            ]
        )
    ]
)
