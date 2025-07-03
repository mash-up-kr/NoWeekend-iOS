import ProjectDescription

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "DiExamTuist",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.DiExamTuist",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "HomeFeature", path: .relativeToRoot("Projects/Home/HomeFeature")),
                .project(target: "ProfileFeature", path: .relativeToRoot("Projects/Profile/ProfileFeature")),
                .project(target: "CalendarFeature", path: .relativeToRoot("Projects/Calendar/CalendarFeature")),
                .project(target: "OnboardingFeature", path: .relativeToRoot("Projects/Onboarding/OnboardingFeature")),
            
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
