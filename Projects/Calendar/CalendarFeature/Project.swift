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
                .project(target: "CalendarDomain", path: .relativeToRoot("Projects/Calendar/CalendarDomain")),
                .project(target: "HomeDomain", path: .relativeToRoot("Projects/Home/HomeDomain")),
                .project(target: "Core", path: .relativeToRoot("Projects/Core")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
