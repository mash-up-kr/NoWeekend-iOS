import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "OnboardingFeature",
    targets: [
        .framework(
            name: "OnboardingFeature",
            bundleId: BundleID.Onboarding.feature,
            sources: ["Sources/**"],
            dependencies: [
                .Onboarding.domain,
                .Shared.designSystem,
                .Shared.utils
            ],
            settings: .frameworkSettings
        )
    ]
)
