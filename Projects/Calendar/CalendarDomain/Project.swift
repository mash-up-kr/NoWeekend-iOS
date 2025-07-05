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
                // 순수 도메인 - 다른 도메인 의존하지 않음
            ]
        )
    ]
)
