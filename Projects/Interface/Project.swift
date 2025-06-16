import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: "Interface",
    targets: [
        .framework(
            name: "Domain",
            bundleId: BundleID.Interface.domain,
            sources: ["Domain/Sources/**"]
        ),
        .framework(
            name: "HomeInterface",
            bundleId: BundleID.Interface.home,
            sources: ["HomeInterface/Sources/**"],
            dependencies: [.target(name: "Domain")]
        ),
        .framework(
            name: "ProfileInterface",
            bundleId: BundleID.Interface.profile,
            sources: ["ProfileInterface/Sources/**"],
            dependencies: [.target(name: "Domain")]
        ),
        .framework(
            name: "CalendarInterface",
            bundleId: BundleID.Interface.calendar,
            sources: ["CalendarInterface/Sources/**"],
            dependencies: [.target(name: "Domain")]
        ),
        .framework(
            name: "RepositoryInterface",
            bundleId: BundleID.Interface.repository,
            sources: ["RepositoryInterface/Sources/**"],
            dependencies: [.target(name: "Domain")]
        ),
        .framework(
            name: "NetworkInterface",
            bundleId: BundleID.Interface.network,
            sources: ["NetworkInterface/Sources/**"]
        ),
        .framework(
            name: "StorageInterface",
            bundleId: BundleID.Interface.storage,
            sources: ["StorageInterface/Sources/**"],
            dependencies: [.target(name: "Domain")]
        ),
        .framework(
            name: "ServiceInterface",
            bundleId: BundleID.Interface.service,
            sources: ["ServiceInterface/Sources/**"],
            dependencies: [.target(name: "Domain")]
        )
    ]
)
