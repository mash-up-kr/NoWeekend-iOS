import ProjectDescription

let project = Project(
    name: "Feature",
    targets: [
        .target(
            name: "TabBar",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.feature.tabbar",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["TabBar/Sources/**"],
            dependencies: [
                .target(name: "Home"),
                .target(name: "Profile"),
                .target(name: "Calendar"),
                .project(target: "DesignSystem", path: "../Shared"),
            ]
        ),
        .target(
            name: "Home",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.feature.home",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Home/Sources/**"],
            dependencies: [
                .project(target: "HomeInterface", path: "../Interface"),
                .project(target: "Domain", path: "../Interface"),
                .project(target: "DesignSystem", path: "../Shared")
            ]
        ),
        .target(
            name: "Calendar",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.feature.calendar",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Calendar/Sources/**"],
            dependencies: [
                .project(target: "CalendarInterface", path: "../Interface"),
                .project(target: "Domain", path: "../Interface"),
                .project(target: "DesignSystem", path: "../Shared")
            ]
        ),
        .target(
            name: "Profile",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.feature.profile",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Profile/Sources/**"],
            dependencies: [
                .project(target: "ProfileInterface", path: "../Interface"),
                .project(target: "Domain", path: "../Interface"),
                .project(target: "DesignSystem", path: "../Shared")
            ]
        ),
        .target(
            name: "Onboarding",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.feature.onboarding",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Onboarding/Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Interface"),
                .project(target: "DesignSystem", path: "../Shared")
            ]
        )
    ]
)
