//
//  Environment.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

// MARK: - Build Configuration
public enum BuildConfiguration: String, CaseIterable {
    case debug = "Debug"
    case release = "Release"
    
    public var bundleIdSuffix: String {
        switch self {
        case .debug: return ".debug"
        case .release: return ""
        }
    }
    
    public var appName: String {
        switch self {
        case .debug: return "NoWeekend-Debug"
        case .release: return "NoWeekend"
        }
    }
    
    public var provisioningProfile: String {
        let baseBundleId = Environment.App.baseBundleId
        switch self {
        case .debug: return "match Development \(baseBundleId)"
        case .release: return "match AppStore \(baseBundleId)"
        }
    }
    
    public var codeSignIdentity: String {
        switch self {
        case .debug: return "Apple Development"
        case .release: return "Apple Distribution"
        }
    }
}

// MARK: - Environment
public struct Environment {
    public static let deploymentTarget = "17.0"
    public static let teamID = "SQ5T25W9V5"
    public static let organizationName = "com.noweekend"
    public static let defaultRegion = "ko"
    
    public struct App {
        public static let baseBundleId = "\(organizationName).app"
        public static let displayName = "NoWeekend"
        public static let version = "1.0.0"
        public static let buildNumber = "1"
        
        public static func bundleId(for configuration: BuildConfiguration = .release) -> String {
            return baseBundleId + configuration.bundleIdSuffix
        }
    }
    
    public static func bundleId(for module: String, configuration: BuildConfiguration = .release) -> String {
        return "\(organizationName).\(module.lowercased())\(configuration.bundleIdSuffix)"
    }
    
    public static func bundleId(category: ModuleCategory, module: String, configuration: BuildConfiguration = .release) -> String {
        return "\(organizationName).\(category.rawValue).\(module.lowercased())\(configuration.bundleIdSuffix)"
    }
}

// MARK: - Module Categories (수정: path 프로퍼티 제거)
public enum ModuleCategory: String, CaseIterable {
    case app = "app"
    case core = "core"
    case feature = "feature"
    case interface = "interface"
    case shared = "shared"
    case plugin = "plugin"
}

// MARK: - Deployment Targets
public extension DeploymentTargets {
    static let `default` = DeploymentTargets.iOS(Environment.deploymentTarget)
    static let iOS16 = DeploymentTargets.iOS("16.0")
    static let iOS15 = DeploymentTargets.iOS("15.0")
    static let iOS14 = DeploymentTargets.iOS("14.0")
}
