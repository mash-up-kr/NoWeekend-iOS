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
                .project(target: "OnboardingDomain", path: .relativeToRoot("Projects/Onboarding/OnboardingDomain")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
