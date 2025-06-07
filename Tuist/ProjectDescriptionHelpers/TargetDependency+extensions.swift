import ProjectDescription

extension TargetDependency {
    public static func external(_ external: ExternalDependency) -> TargetDependency {
        return .external(name: external.rawValue)
    }

    public static func module(_ name: TargetName) -> TargetDependency {
        return .project(target: name.rawValue, path: .relativeToRoot(name.projectPath))
    }
}

public enum ProjectPath: String, CaseIterable {
    case app = "Projects/App"
    case core = "Projects/Core"
    case designSystem = "Projects/DesignSystem"
    case features = "Projects/Features"
}

public enum TargetName: String, CaseIterable {
    case app = "App"
    case core = "Core"
    case designSystem = "DesignSystem"
    case features = "Features"

    var projectPath: String {
        switch self {
        case .app: return ProjectPath.app.rawValue
        case .core: return ProjectPath.core.rawValue
        case .designSystem: return ProjectPath.designSystem.rawValue
        case .features: return ProjectPath.features.rawValue
        }
    }
}

public enum ExternalDependency: String, CaseIterable {
    case googleSignIn = "GoogleSignIn"
    case alamofire = "Alamofire"
}
