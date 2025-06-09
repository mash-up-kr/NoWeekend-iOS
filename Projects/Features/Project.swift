import ProjectDescription

let project = Project(
    name: "Features",
    targets: [
        // Home 타겟 - Domain, DesignSystem, Util, Common 참조
        .target(
            name: "Home",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.home",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Home/Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Core"),
                .project(target: "DesignSystem", path: "../UI"),
                .project(target: "Util", path: "../Core"),
                .project(target: "Common", path: "../Core")
            ]
        ),
        // Calendar 타겟
        .target(
            name: "Calendar",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.calendar",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Calendar/Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Core"),
                .project(target: "DesignSystem", path: "../UI"),
                .project(target: "Util", path: "../Core"),
                .project(target: "Common", path: "../Core")
            ]
        ),
        // Profile 타겟
        .target(
            name: "Profile",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.profile",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Profile/Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Core"),
                .project(target: "DesignSystem", path: "../UI"),
                .project(target: "Util", path: "../Core"),
                .project(target: "Common", path: "../Core")
            ]
        ),
        // OnBoarding 타겟 - DesignSystem만
        .target(
            name: "OnBoarding",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.onboarding",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["OnBoarding/Sources/**"],
            dependencies: [
                .project(target: "DesignSystem", path: "../UI")
            ]
        ),
        // TabBar 타겟 - Features들과 DesignSystem 참조
        .target(
            name: "TabBar",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.tabbar",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["TabBar/Sources/**"],
            dependencies: [
                .target(name: "Home"),
                .target(name: "Calendar"),
                .target(name: "Profile"),
                .project(target: "DesignSystem", path: "../UI")
            ]
        )
    ]
)
