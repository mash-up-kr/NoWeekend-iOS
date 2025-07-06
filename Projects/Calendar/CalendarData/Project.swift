import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "CalendarData",
    targets: [
        .framework(
            name: "CalendarData",
            bundleId: BundleID.Calendar.data,
            sources: ["Sources/**"],
            dependencies: [
                .Calendar.domain,
                .Core.diContainer
            ]
        )
    ]
)
