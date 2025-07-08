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
                .Home.domain,
                .Core.coordinator,
                .Core.diContainer,
                .Shared.designSystem,
                .Shared.utils
            ],
            settings: .frameworkSettings
        )
    ]
)
