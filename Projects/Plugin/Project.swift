import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Plugin",
    targets: [
        .framework(
            name: "Analytics",
            bundleId: BundleID.Plugin.analytics,
            sources: ["Analytics/Sources/**"],
            dependencies: [
                // 일단 외부 의존성 없이 독립적으로 구성
                // 필요하면 나중에 추가
            ]
        ),
        .framework(
            name: "Push",
            bundleId: BundleID.Plugin.push,
            sources: ["Push/Sources/**"],
            dependencies: [
                // 일단 외부 의존성 없이 독립적으로 구성
                // 필요하면 나중에 추가
            ]
        ),
        .framework(
            name: "ThirdParty",
            bundleId: BundleID.Plugin.thirdParty,
            sources: ["ThirdParty/Sources/**"],
            dependencies: [
                // ThirdParty 라이브러리들
                .external(.alamofire),
                .external(.lottie),
                .external(.swinject)
            ]
        )
    ]
)
