//
//  TargetDependency+extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

extension TargetDependency {
    // 외부 의존성
    public static func external(_ dependency: ExternalDependency) -> TargetDependency {
        return .external(name: dependency.rawValue)
    }
    
    // 같은 프로젝트 내 타겟
    public static func target(_ name: String) -> TargetDependency {
        return .target(name: name)
    }
    
    // 다른 프로젝트의 타겟 (일반적인 방법)
    public static func project(target: String, path: String) -> TargetDependency {
        return .project(target: target, path: .relativeToRoot(path))
    }
    
    // Shared 모듈들
    public static func shared(_ shared: SharedModule) -> TargetDependency {
        return .project(target: shared.rawValue, path: "Projects/Shared")
    }
    
    // Core 모듈들
    public static func core(_ core: CoreModule) -> TargetDependency {
        return .project(target: core.rawValue, path: "Projects/Core")
    }
    
    // Plugin 모듈들
    public static func plugin(_ plugin: PluginModule) -> TargetDependency {
        return .project(target: plugin.rawValue, path: "Projects/Plugin")
    }
    
    // MARK: - Feature
    
    // Home 모듈들
    public static func homeDomain() -> TargetDependency {
        return .project(target: "HomeDomain", path: "Projects/Home/HomeDomain")
    }
    
    public static func homeData() -> TargetDependency {
        return .project(target: "HomeData", path: "Projects/Home/HomeData")
    }
    
    public static func homeFeature() -> TargetDependency {
        return .project(target: "HomeFeature", path: "Projects/Home/HomeFeature")
    }
    
    // Profile 모듈들
    public static func profileDomain() -> TargetDependency {
        return .project(target: "ProfileDomain", path: "Projects/Profile/ProfileDomain")
    }
    
    public static func profileData() -> TargetDependency {
        return .project(target: "ProfileData", path: "Projects/Profile/ProfileData")
    }
    
    public static func profileFeature() -> TargetDependency {
        return .project(target: "ProfileFeature", path: "Projects/Profile/ProfileFeature")
    }
    
    // Calendar 모듈들
    public static func calendarDomain() -> TargetDependency {
        return .project(target: "CalendarDomain", path: "Projects/Calendar/CalendarDomain")
    }
    
    public static func calendarData() -> TargetDependency {
        return .project(target: "CalendarData", path: "Projects/Calendar/CalendarData")
    }
    
    public static func calendarFeature() -> TargetDependency {
        return .project(target: "CalendarFeature", path: "Projects/Calendar/CalendarFeature")
    }
    
    // Onboarding 모듈들
    public static func onboardingDomain() -> TargetDependency {
        return .project(target: "OnboardingDomain", path: "Projects/Onboarding/OnboardingDomain")
    }
    
    public static func onboardingData() -> TargetDependency {
        return .project(target: "OnboardingData", path: "Projects/Onboarding/OnboardingData")
    }
    
    public static func onboardingFeature() -> TargetDependency {
        return .project(target: "OnboardingFeature", path: "Projects/Onboarding/OnboardingFeature")
    }
}

// MARK: - External Dependencies Extension
extension TargetDependency {
    public static func swinject() -> TargetDependency {
        return .external(name: "Swinject")
    }
}
