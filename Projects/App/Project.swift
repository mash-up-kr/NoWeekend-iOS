import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "App",
    targets: [
        .app(
            name: "App",
            bundleId: Environment.App.baseBundleId,
            infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
            dependencies: [
                // DI 모듈만 의존 (Needle 기반)
                .target(name: "DI"),
                
                // UI 컴포넌트만 의존
                .shared(.designSystem)
            ]
        ),
        .framework(
            name: "DI",
            bundleId: Environment.bundleId(category: .app, module: "di"),
            sources: [
                "DI/Sources/**",
                "../Feature/Home/Interface/Sources/**",
                "../Feature/Profile/Interface/Sources/**",
                "../Feature/Calendar/Interface/Sources/**",
                "../Feature/Onboarding/Interface/Sources/**"
            ],
            scripts: [
                .pre(
                    script: "$NEEDLE_BINARY" generate \
                        --header-doc="" \
                        "$GENERATED_FILE" \
                        "${SRCROOT}/Projects/App/DI/Sources",
                    name: "Needle Generate"
                )
            ],
            dependencies: [
                // Feature 구현체들 (DI에서만 알고 있음)
                .feature(.home),
                .feature(.profile),
                .feature(.calendar),
                .feature(.onboarding),
                .feature(.calendarInterface),
                .feature(.profileInterface),
                .feature(.homeInterface)

                .external(.needle)
            ]
        )
    ]
)