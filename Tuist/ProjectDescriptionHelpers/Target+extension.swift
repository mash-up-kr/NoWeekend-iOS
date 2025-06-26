//
//  Target+extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

extension Target {
    public static func framework(
        name: String,
        bundleId: String? = nil,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = .frameworkSettings
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: bundleId ?? Environment.bundleId(for: name),
            deploymentTargets: .iOS(Environment.deploymentTarget),
            infoPlist: .default,
            sources: sources,
            resources: resources,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings
        )
    }
    
    public static func app(
        name: String,
        bundleId: String? = nil,
        infoPlist: InfoPlist? = nil,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements = ["Resources/**"],
        dependencies: [TargetDependency] = [],
        settings: Settings? = .appSettings()
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId ?? Environment.App.baseBundleId,
            deploymentTargets: .iOS(Environment.deploymentTarget),
            infoPlist: infoPlist ?? .app(displayName: Environment.App.displayName),
            sources: sources,
            resources: resources,
            dependencies: dependencies,
            settings: settings
        )
    }
}
