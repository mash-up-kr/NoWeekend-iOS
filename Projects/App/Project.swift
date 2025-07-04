import ProjectDescription

let project = Project(
    name: "NoWeekend",
    targets: [
        .target(
            name: "NoWeekend",
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
                // Feature 모듈들
                .project(target: "HomeFeature", path: .relativeToRoot("Projects/Home/HomeFeature")),
                .project(target: "ProfileFeature", path: .relativeToRoot("Projects/Profile/ProfileFeature")),
                .project(target: "CalendarFeature", path: .relativeToRoot("Projects/Calendar/CalendarFeature")),
                
                // Data 모듈들 (DI 등록을 위해 직접 의존)
                .project(target: "HomeData", path: .relativeToRoot("Projects/Home/HomeData")),
                .project(target: "ProfileData", path: .relativeToRoot("Projects/Profile/ProfileData")),
                .project(target: "CalendarData", path: .relativeToRoot("Projects/Calendar/CalendarData")),
                
                // Core 모듈
                .project(target: "Core", path: .relativeToRoot("Projects/Core")),
                
                // Shared 모듈들
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
