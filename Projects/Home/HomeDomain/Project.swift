import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "HomeDomain",
    targets: [
        .framework(
            name: "HomeDomain",
            bundleId: BundleID.Home.domain,
            sources: ["Sources/**"],
            dependencies: [
                // 순수 도메인 - 아무것도 의존하지 않음
            ]
        )
    ]
)
