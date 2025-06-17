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
    
    // 다른 프로젝트의 타겟
    public static func project(target: String, path: ProjectPath) -> TargetDependency {
        return .project(target: target, path: path.relativePath)
    }
    
    // Interface 모듈들
    public static func interface(_ interface: InterfaceModule) -> TargetDependency {
        return .project(target: interface.rawValue, path: .interface)
    }
    
    // Feature 모듈들
    public static func feature(_ feature: FeatureModule) -> TargetDependency {
        return .project(target: feature.rawValue, path: .feature)
    }
    
    // Shared 모듈들
    public static func shared(_ shared: SharedModule) -> TargetDependency {
        return .project(target: shared.rawValue, path: .shared)
    }
    
    // Core 모듈들
    public static func core(_ core: CoreModule) -> TargetDependency {
        return .project(target: core.rawValue, path: .core)
    }
    
    // Plugin 모듈들
    public static func plugin(_ plugin: PluginModule) -> TargetDependency {
        return .project(target: plugin.rawValue, path: .plugin)
    }
}
