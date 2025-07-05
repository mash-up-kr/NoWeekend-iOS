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
                .project(target: "CalendarDomain", path: .relativeToRoot("Projects/Calendar/CalendarDomain")),
                .project(target: "Network", path: .relativeToRoot("Projects/Core")),
                .project(target: "DIContainer", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
