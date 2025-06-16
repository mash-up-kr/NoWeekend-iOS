//
//  Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

// MARK: - Project Paths
public enum ProjectPath: String, CaseIterable {
    case app = "Projects/App"
    case core = "Projects/Core"
    case feature = "Projects/Feature"
    case interface = "Projects/Interface"
    case shared = "Projects/Shared"
    case plugin = "Projects/Plugin"
    
    public var relativePath: Path {
        return .relativeToRoot(self.rawValue)
    }
}

// MARK: - External Dependencies
public enum ExternalDependency: String, CaseIterable {
    case alamofire = "Alamofire"
    case lottie = "Lottie"
}

// MARK: - Interface Modules
public enum InterfaceModule: String, CaseIterable {
    case domain = "Domain"
    case homeInterface = "HomeInterface"
    case profileInterface = "ProfileInterface"
    case calendarInterface = "CalendarInterface"
    case repositoryInterface = "RepositoryInterface"
    case networkInterface = "NetworkInterface"
    case storageInterface = "StorageInterface"
    case serviceInterface = "ServiceInterface"
}

// MARK: - Feature Modules
public enum FeatureModule: String, CaseIterable {
    case tabBar = "TabBar"
    case home = "Home"
    case calendar = "Calendar"
    case profile = "Profile"
    case onboarding = "Onboarding"
}

// MARK: - Shared Modules
public enum SharedModule: String, CaseIterable {
    case utils = "Utils"
    case designSystem = "DesignSystem"
}

// MARK: - Core Modules
public enum CoreModule: String, CaseIterable {
    case useCase = "UseCase"
    case repository = "Repository"
    case network = "Network"
    case storage = "Storage"
}

// MARK: - Plugin Modules
public enum PluginModule: String, CaseIterable {
    case analytics = "Analytics"
    case push = "Push"
    case thirdParty = "ThirdParty"
}
