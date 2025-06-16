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
        return Project(
            name: name,
            organizationName: organizationName,
            options: .options(
                automaticSchemesOptions: .disabled,
                defaultKnownRegions: [Environment.defaultRegion],
                developmentRegion: Environment.defaultRegion,
                textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
            ),
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes ?? [],
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}
