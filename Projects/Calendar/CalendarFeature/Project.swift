import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "CalendarFeature",
    targets: [
        .framework(
            name: "CalendarFeature",
            bundleId: BundleID.Calendar.feature,
            sources: ["Sources/**"],
            dependencies: [
                .Calendar.domain,
                .Core.coordinator,
                .Core.diContainer,
                .Shared.designSystem,
                .Shared.utils
            ]
        ),
        
        .app(
            name: "CalendarExampleApp",
            bundleId: "com.noweekend.calendar.example",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "Calendar Example",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["Example/Sources/**"],
            resources: [], 
            dependencies: [
                .target(name: "CalendarFeature"),
                .Calendar.domain,
                .Calendar.data,
                .Core.diContainer,
                .Core.coordinator,
                .Core.nwnetwork,
                .Shared.designSystem,
                .Shared.utils
            ]
        ),
        
        .target(
            name: "CalendarFeatureTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.noweekend.calendar.tests",
            deploymentTargets: .iOS("15.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "CalendarFeature"),
                .Calendar.domain
            ]
        )
    ]
)
