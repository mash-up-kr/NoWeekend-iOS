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
                .project(target: "Core", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
