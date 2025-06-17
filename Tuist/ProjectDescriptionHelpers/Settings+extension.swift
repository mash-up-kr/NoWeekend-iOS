//
//  Settings+extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

public extension Settings {
    /// 프레임워크용 기본 설정
    static let frameworkSettings: Settings = .settings(
        base: [
            "SKIP_INSTALL": "YES",
            "BUILD_LIBRARY_FOR_DISTRIBUTION": "YES",
            "DEFINES_MODULE": "YES",
            "ENABLE_BITCODE": "NO",
            "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deploymentTarget),
            "SWIFT_VERSION": "5.0",
            "CLANG_ENABLE_MODULES": "YES"
        ]
    )
    
    /// 테스트용 기본 설정
    static let testSettings: Settings = .settings(
        base: [
            "ENABLE_TESTING_SEARCH_PATHS": "YES",
            "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "YES",
            "ENABLE_TESTABILITY": "YES",
            "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deploymentTarget),
            "SWIFT_VERSION": "5.0"
        ]
    )
    
    /// 앱용 설정
    static func appSettings(
        teamID: String = Environment.teamID
    ) -> Settings {
        let baseSettings: [String: SettingValue] = [
            "CODE_SIGN_STYLE": "Manual",
            "DEVELOPMENT_TEAM": .string(teamID),
            "MARKETING_VERSION": .string(Environment.App.version),
            "CURRENT_PROJECT_VERSION": .string(Environment.App.buildNumber),
            "ENABLE_BITCODE": "NO",
            "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deploymentTarget),
            "SWIFT_VERSION": "5.0",
            "CLANG_ENABLE_MODULES": "YES"
        ]
        
        let debugSettings: [String: SettingValue] = [
            "PRODUCT_NAME": .string(BuildConfiguration.debug.appName),
            "PROVISIONING_PROFILE_SPECIFIER": .string(BuildConfiguration.debug.provisioningProfile),
            "CODE_SIGN_IDENTITY": .string(BuildConfiguration.debug.codeSignIdentity),
            "ENABLE_TESTABILITY": "YES",
            "GCC_OPTIMIZATION_LEVEL": "0",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "DEBUG_INFORMATION_FORMAT": "dwarf",
            "GCC_PREPROCESSOR_DEFINITIONS": .array(["DEBUG=1"])
        ]
        
        let releaseSettings: [String: SettingValue] = [
            "PRODUCT_NAME": .string(BuildConfiguration.release.appName),
            "PROVISIONING_PROFILE_SPECIFIER": .string(BuildConfiguration.release.provisioningProfile),
            "CODE_SIGN_IDENTITY": .string(BuildConfiguration.release.codeSignIdentity),
            "SWIFT_OPTIMIZATION_LEVEL": "-O",
            "ENABLE_TESTABILITY": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "SWIFT_COMPILATION_MODE": "wholemodule"
        ]
        
        return .settings(
            base: baseSettings,
            configurations: [
                .debug(name: .debug, settings: debugSettings),
                .release(name: .release, settings: releaseSettings)
            ]
        )
    }
    
    /// 데모 앱용 설정
    static let demoAppSettings: Settings = .settings(
        base: [
            "CODE_SIGN_STYLE": "Automatic",
            "DEVELOPMENT_TEAM": .string(Environment.teamID),
            "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deploymentTarget),
            "SWIFT_VERSION": "5.0",
            "ENABLE_TESTABILITY": "YES"
        ]
    )
}
