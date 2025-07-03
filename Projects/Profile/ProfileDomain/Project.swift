import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "ProfileDomain",
    targets: [
        .framework(
            name: "ProfileDomain",
            bundleId: BundleID.Profile.domain,
            sources: ["Sources/**"],
            dependencies: [
                // 순수 도메인 - 아무것도 의존하지 않음
            ]
        )
    ]
)
