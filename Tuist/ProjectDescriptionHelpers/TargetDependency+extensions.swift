//
//  TargetDependency+Extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

// MARK: - TargetDependency Extensions
public extension TargetDependency {
    
    // MARK: - External Dependencies
    static func external(_ dependency: ExternalDependency) -> TargetDependency {
        return .external(name: dependency.rawValue)
    }
    
    // MARK: - Core Modules
    static func core(_ module: CoreModule) -> TargetDependency {
        return .project(target: module.rawValue, path: ProjectPath.core.relativePath)
    }
    
    // MARK: - Shared Modules
    static func shared(_ module: SharedModule) -> TargetDependency {
        return .project(target: module.rawValue, path: ProjectPath.shared.relativePath)
    }
    
    // MARK: - Plugin Modules
    static func plugin(_ module: PluginModule) -> TargetDependency {
        return .project(target: module.rawValue, path: ProjectPath.plugin.relativePath)
    }
    
    // MARK: - Feature Modules
    static func feature(_ module: FeatureModule) -> TargetDependency {
        switch module {
        // Home
        case .homeFeature:
            return .project(target: module.rawValue, path: ProjectPath.homeFeature.relativePath)
        case .homeDomain:
            return .project(target: module.rawValue, path: ProjectPath.homeDomain.relativePath)
        case .homeData:
            return .project(target: module.rawValue, path: ProjectPath.homeData.relativePath)
            
        // Profile
        case .profileFeature:
            return .project(target: module.rawValue, path: ProjectPath.profileFeature.relativePath)
        case .profileDomain:
            return .project(target: module.rawValue, path: ProjectPath.profileDomain.relativePath)
        case .profileData:
            return .project(target: module.rawValue, path: ProjectPath.profileData.relativePath)
            
        // Calendar
        case .calendarFeature:
            return .project(target: module.rawValue, path: ProjectPath.calendarFeature.relativePath)
        case .calendarDomain:
            return .project(target: module.rawValue, path: ProjectPath.calendarDomain.relativePath)
        case .calendarData:
            return .project(target: module.rawValue, path: ProjectPath.calendarData.relativePath)
            
        // Onboarding
        case .onboardingFeature:
            return .project(target: module.rawValue, path: ProjectPath.onboardingFeature.relativePath)
        case .onboardingDomain:
            return .project(target: module.rawValue, path: ProjectPath.onboardingDomain.relativePath)
        case .onboardingData:
            return .project(target: module.rawValue, path: ProjectPath.onboardingData.relativePath)
        
        // Login
        case .loginFeature:
            return .project(target: module.rawValue, path: ProjectPath.loginFeature.relativePath)
        case .loginDomain:
            return .project(target: module.rawValue, path: ProjectPath.loginDomain.relativePath)
        case .loginData:
            return .project(target: module.rawValue, path: ProjectPath.loginData.relativePath)
        }
    }
}

// MARK: - Convenience Extensions for specific Features
public extension TargetDependency {
    
    // MARK: - Home Module Dependencies
    enum Home {
        public static let feature = TargetDependency.feature(.homeFeature)
        public static let domain = TargetDependency.feature(.homeDomain)
        public static let data = TargetDependency.feature(.homeData)
    }
    
    // MARK: - Profile Module Dependencies
    enum Profile {
        public static let feature = TargetDependency.feature(.profileFeature)
        public static let domain = TargetDependency.feature(.profileDomain)
        public static let data = TargetDependency.feature(.profileData)
    }
    
    // MARK: - Calendar Module Dependencies
    enum Calendar {
        public static let feature = TargetDependency.feature(.calendarFeature)
        public static let domain = TargetDependency.feature(.calendarDomain)
        public static let data = TargetDependency.feature(.calendarData)
    }
    
    // MARK: - Onboarding Module Dependencies
    enum Onboarding {
        public static let feature = TargetDependency.feature(.onboardingFeature)
        public static let domain = TargetDependency.feature(.onboardingDomain)
        public static let data = TargetDependency.feature(.onboardingData)
    }
    
    enum Login {
        public static let feature = TargetDependency.feature(.loginFeature)
        public static let domain = TargetDependency.feature(.loginDomain)
        public static let data = TargetDependency.feature(.loginData)
    }
    
    // MARK: - Core Module Dependencies
    enum Core {
        public static let nwnetwork = TargetDependency.core(.nwnetwork)
        public static let diContainer = TargetDependency.core(.diContainer)
        public static let coordinator = TargetDependency.core(.coordinator)
    }
    
    // MARK: - Shared Module Dependencies
    enum Shared {
        public static let utils = TargetDependency.shared(.utils)
        public static let designSystem = TargetDependency.shared(.designSystem)
    }
    
    // MARK: - External Dependencies
    enum External {
        public static let alamofire = TargetDependency.external(.alamofire)
        public static let lottie = TargetDependency.external(.lottie)
        public static let swinject = TargetDependency.external(.swinject)
        public static let googleSignIn = TargetDependency.external(.googleSignIn)
    }
    
    // MARK: - Special Modules
    enum Bridge {
        public static let dataBridge = TargetDependency.project(
            target: "DataBridge",
            path: .relativeToRoot("Projects/DataBridge")
        )
    }
}
