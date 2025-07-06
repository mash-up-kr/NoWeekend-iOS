import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "OnboardingDomain",
    targets: [
        .framework(
            name: "OnboardingDomain",
            bundleId: BundleID.Onboarding.domain,
            sources: ["Sources/**"],
            dependencies: [
            ]
        )
    ]
)
