import ProjectDescription

let project = Project(
    name: "Interface",
    targets: [
        // 🔹 Domain (공통 엔티티)
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.domain",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Domain/Sources/**"],
            dependencies: []
        ),
        
        // 🔹 Feature 인터페이스들
        .target(
            name: "HomeInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.home",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["HomeInterface/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        ),
        .target(
            name: "ProfileInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.profile",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["ProfileInterface/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        ),
        .target(
            name: "CalendarInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.calendar",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["CalendarInterface/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        ),
        
        // 🔹 Service 인터페이스들
        .target(
            name: "RepositoryInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.repository",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["RepositoryInterface/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        ),
        .target(
            name: "NetworkInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.network",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["NetworkInterface/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "StorageInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.storage",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["StorageInterface/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        ),
        .target(
            name: "ServiceInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.noweekend.interface.service",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["ServiceInterface/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        )
    ]
)
