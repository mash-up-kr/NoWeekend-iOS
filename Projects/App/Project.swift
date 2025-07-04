import ProjectDescription

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.noweekend.app",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "NoWeekend",
                    "CFBundleName": "NoWeekend",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "HomeFeature", path: .relativeToRoot("Projects/Home/HomeFeature")),
                .project(target: "ProfileFeature", path: .relativeToRoot("Projects/Profile/ProfileFeature")),
                .project(target: "CalendarFeature", path: .relativeToRoot("Projects/Calendar/CalendarFeature")),
                .project(target: "OnboardingFeature", path: .relativeToRoot("Projects/Onboarding/OnboardingFeature")),
                
                // Data 모듈들 대신 DataBridge만 의존
                .project(target: "DataBridge", path: .relativeToRoot("Projects/DataBridge")),
                
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
