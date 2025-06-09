import ProjectDescription

let project = Project(
    name: "Core",
    targets: [
        // Common 타겟
        .target(
            name: "Common",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.common",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Common/Sources/**"],
            dependencies: []
        ),
        // Util 타겟
        .target(
            name: "Util",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.util",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Util/Sources/**"],
            dependencies: [
                .target(name: "Common")
            ]
        ),
        // Domain 타겟
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.domain",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Domain/Sources/**"],
            dependencies: []
        ),
        // Network 타겟
        .target(
            name: "Network",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.network",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Network/Sources/**"],
            dependencies: [
                .target(name: "Common"),
                .external(name: "Alamofire")
            ]
        ),
        // Storage 타겟
        .target(
            name: "Storage",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.storage",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Storage/Sources/**"],
            dependencies: [
                .target(name: "Common")
            ]
        ),
        // Data 타겟
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.data",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "Network"),
                .target(name: "Storage"),
                .target(name: "Domain"),
                .target(name: "Util")
            ]
        )
    ]
)
