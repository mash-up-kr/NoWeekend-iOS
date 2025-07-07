import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "App",
    targets: [
        .app(
            name: "App",
            bundleId: BundleID.app,
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
                .Home.feature,
                .Profile.feature,
                .Calendar.feature,
                .Onboarding.feature,
                .Login.feature,
                .Bridge.dataBridge,
                .Shared.designSystem,
                .Shared.utils,
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": "$(inherited) -ObjC"
                ]
            )
        )
    ],
    resourceSynthesizers: [
        .custom(
            name: "Fonts",
            parser: .fonts,
            extensions: ["ttf", "otf"]
        ),
        .custom(
            name: "Strings",
            parser: .strings,
            extensions: ["strings"]
        )
    ]
)
