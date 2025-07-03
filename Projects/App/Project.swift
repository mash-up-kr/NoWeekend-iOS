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
                .project(target: "HomeFeature", path: .relativeToRoot("Projects/Home/HomeFeature")),
                .project(target: "ProfileFeature", path: .relativeToRoot("Projects/Profile/ProfileFeature")),
                .project(target: "CalendarFeature", path: .relativeToRoot("Projects/Calendar/CalendarFeature")),
                
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
                
            ]
        )
    ]
)
