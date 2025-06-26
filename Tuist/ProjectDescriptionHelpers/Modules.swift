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
    case data = "Projects/Data"
    case domain = "Projects/Domain"
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
    case needle = "NeedleFoundation"
}

// MARK: - Feature Modules
public enum FeatureModule: String, CaseIterable {
    case tabBar = "TabBar"
    case home = "Home"
    case calendar = "Calendar"
    case profile = "Profile"
    case onboarding = "Onboarding"

    case homeInterface = "HomeInterface"
    case profileInterface = "ProfileInterface"
    case calendarInterface = "CalendarInterface"
    case onboardingInterface = "OnboardingInterface"
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

// MARK: - Domain Modules
public enum DomainModule: String, CaseIterable {
    case entity = "Entity"
    case repositoryInterface = "RepositoryInterface"
    case serviceInterface = "ServiceInterface"
    case useCase = "UseCase"
}

// MARK: - Data Modules
public enum DataModule: String, CaseIterable {
    case repository = "Repository"
    case storage = "Storage"
}