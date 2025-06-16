import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: "Feature",
    targets: [
        .framework(
            name: "TabBar",
            bundleId: BundleID.Feature.tabBar,
            sources: ["TabBar/Sources/**"],
            dependencies: [
                .target(name: "Home"),
                .target(name: "Profile"),
                .target(name: "Calendar"),
                .shared(.designSystem)
            ]
        ),
        .framework(
            name: "Home",
            bundleId: BundleID.Feature.home,
            sources: ["Home/Sources/**"],
            dependencies: [
                .interface(.homeInterface),
                .interface(.domain),
                .shared(.designSystem)
            ]
        ),
        .framework(
            name: "Calendar",
            bundleId: BundleID.Feature.calendar,
            sources: ["Calendar/Sources/**"],
            dependencies: [
                .interface(.calendarInterface),
                .interface(.domain),
                .shared(.designSystem)
            ]
        ),
        .framework(
            name: "Profile",
            bundleId: BundleID.Feature.profile,
            sources: ["Profile/Sources/**"],
            dependencies: [
                .interface(.profileInterface),
                .interface(.domain),
                .shared(.designSystem)
            ]
        ),
        .framework(
            name: "Onboarding",
            bundleId: BundleID.Feature.onboarding,
            sources: ["Onboarding/Sources/**"],
            dependencies: [
                .interface(.domain),
                .shared(.designSystem)
            ]
        )
    ]
)
