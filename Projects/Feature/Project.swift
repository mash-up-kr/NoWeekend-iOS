import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Feature",
    targets: [
        // MARK: - Feature Interfaces (Protocol Definitions)
        .framework(
            name: "HomeInterface",
            bundleId: BundleID.Feature.homeInterface,
            sources: ["Home/Interface/Sources/**"],
            dependencies: [
                .project(target: "Entity", path: "../Domain")
            ]
        ),
        .framework(
            name: "ProfileInterface",
            bundleId: BundleID.Feature.profileInterface,
            sources: ["Profile/Interface/Sources/**"],
            dependencies: [
                .project(target: "Entity", path: "../Domain")
            ]
        ),
        .framework(
            name: "CalendarInterface",
            bundleId: BundleID.Feature.calendarInterface,
            sources: ["Calendar/Interface/Sources/**"],
            dependencies: [
                .project(target: "Entity", path: "../Domain")
            ]
        ),
        .framework(
            name: "OnboardingInterface",
            bundleId: BundleID.Feature.onboardingInterface,
            sources: ["Onboarding/Interface/Sources/**"],
            dependencies: [
                .project(target: "Entity", path: "../Domain")
            ]
        ),

        // MARK: - Home MVI
        .framework(
            name: "Home",
            bundleId: BundleID.Feature.home,
            sources: ["Home/Sources/**"],
            dependencies: [
                .target(name: "HomeInterface"),
                .project(target: "UseCase", path: "../Domain"),
                .shared(.designSystem)
            ]
        ),

        // MARK: - Profile MVI
        .framework(
            name: "Profile",
            bundleId: BundleID.Feature.profile,
            sources: ["Profile/Sources/**"],
            dependencies: [
                .target(name: "ProfileInterface"),
                .project(target: "UseCase", path: "../Domain"),
                .shared(.designSystem)
            ]
        ),

        // MARK: - Calendar MVI
        .framework(
            name: "Calendar",
            bundleId: BundleID.Feature.calendar,
            sources: ["Calendar/Sources/**"],
            dependencies: [
                .target(name: "CalendarInterface"),
                .project(target: "UseCase", path: "../Domain"),
                .shared(.designSystem)
            ]
        ),

        // MARK: - Onboarding MVI
        .framework(
            name: "Onboarding",
            bundleId: BundleID.Feature.onboarding,
            sources: ["Onboarding/Sources/**"],
            dependencies: [
                .target(name: "OnboardingInterface"),
                .shared(.designSystem)
            ]
        )
    ]
)
