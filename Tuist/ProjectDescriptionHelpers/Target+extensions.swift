import ProjectDescription


extension Target {
    public static func make(
        name: String,
        destinations: Set<Destination> = [.iPhone],
        product: Product,
        bundleId: String,
        path: ProjectPath,
        deploymentTargets: DeploymentTargets = .iOS("17.0"),
        infoPlist: InfoPlist? = nil,
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        scripts: [TargetScript] = []
    ) -> Target {
        let defaultInfoPlist: InfoPlist = .file(path: .relativeToRoot("\(path.rawValue)/Info.plist"))
        let defaultSources: SourceFilesList = ["\(path.rawValue)/Sources/**"]
        let defaultResources: ResourceFileElements = ["\(path.rawValue)/Resources/**"]
        
        return .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: bundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist ?? defaultInfoPlist,
            sources: sources ?? defaultSources,
            resources: resources ?? defaultResources,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings
        )
    }
}
