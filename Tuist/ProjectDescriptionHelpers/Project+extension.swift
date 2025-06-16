//
//  Project+extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

extension Project {
    public static func make(
        name: String,
        organizationName: String = Environment.organizationName,
        packages: [Package] = [],
        settings: Settings? = nil,
        targets: [Target] = [],
        schemes: [Scheme]? = nil,
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) -> Project {
        if let schemes = schemes {
            return Project(
                name: name,
                organizationName: organizationName,
                packages: packages,
                settings: settings,
                targets: targets,
                schemes: schemes,
                fileHeaderTemplate: fileHeaderTemplate,
                additionalFiles: additionalFiles,
                resourceSynthesizers: resourceSynthesizers
            )
        } else {
            return Project(
                name: name,
                organizationName: organizationName,
                packages: packages,
                settings: settings,
                targets: targets,
                fileHeaderTemplate: fileHeaderTemplate,
                additionalFiles: additionalFiles,
                resourceSynthesizers: resourceSynthesizers
            )
        }
    }
}
