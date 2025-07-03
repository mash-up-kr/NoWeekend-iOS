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
                .project(target: "HomeDomain", path: .relativeToRoot("Projects/Home/HomeDomain")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared")),
                .project(target: "Utils", path: .relativeToRoot("Projects/Shared"))
            ]
        )
    ]
)
