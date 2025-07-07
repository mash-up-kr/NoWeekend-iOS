import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "CalendarDomain",
    targets: [
        .framework(
            name: "CalendarDomain",
            bundleId: BundleID.Calendar.domain,
            sources: ["Sources/**"],
            dependencies: [
            ],
            settings: .frameworkSettings
        )
    ]
)
