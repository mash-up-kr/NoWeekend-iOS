import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "HomeFeature",
    targets: [
        .framework(
            name: "HomeFeature",
            bundleId: BundleID.Home.feature,
            sources: ["Sources/**"],
            dependencies: [
                .Home.domain,
                .Calendar.domain,
                .Profile.domain,
                .Core.diContainer,
                .Core.coordinator,
                .Shared.designSystem,
                .Shared.utils
            ],
            settings: .frameworkSettings
        ),
        // 홈 모듈 독립 실행을 위한 데모 앱
        .app(
            name: "HomeDemoApp",
            bundleId: "com.noweekend.home.demo",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "Home Demo",
                "UILaunchStoryboardName": "LaunchScreen",
                "UISupportedInterfaceOrientations": .array([
                    .string("UIInterfaceOrientationPortrait")
                ])
            ]),
            sources: ["Demo/Sources/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [
                .Home.feature,
                .Home.data,
                .Bridge.dataBridge
            ],
            settings: .demoAppSettings
        )
    ]
)
