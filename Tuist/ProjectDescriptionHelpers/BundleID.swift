//
//  BundleID.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

public struct BundleID {
    public static let app = Environment.App.baseBundleId
    
    public struct Core {
        public static let useCase = Environment.bundleId(category: .core, module: "usecase")
        public static let repository = Environment.bundleId(category: .core, module: "repository")
        public static let network = Environment.bundleId(category: .core, module: "network")
        public static let storage = Environment.bundleId(category: .core, module: "storage")
    }
    
    public struct Feature {
        public static let tabBar = Environment.bundleId(category: .feature, module: "tabbar")
        public static let home = Environment.bundleId(category: .feature, module: "home")
        public static let calendar = Environment.bundleId(category: .feature, module: "calendar")
        public static let profile = Environment.bundleId(category: .feature, module: "profile")
        public static let onboarding = Environment.bundleId(category: .feature, module: "onboarding")
    }
    
    public struct Interface {
        public static let domain = Environment.bundleId(category: .interface, module: "domain")
        public static let home = Environment.bundleId(category: .interface, module: "home")
        public static let profile = Environment.bundleId(category: .interface, module: "profile")
        public static let calendar = Environment.bundleId(category: .interface, module: "calendar")
        public static let repository = Environment.bundleId(category: .interface, module: "repository")
        public static let network = Environment.bundleId(category: .interface, module: "network")
        public static let storage = Environment.bundleId(category: .interface, module: "storage")
        public static let service = Environment.bundleId(category: .interface, module: "service")
    }
    
    public struct Shared {
        public static let utils = Environment.bundleId(category: .shared, module: "utils")
        public static let designSystem = Environment.bundleId(category: .shared, module: "designsystem")
    }
    
    public struct Plugin {
        public static let analytics = Environment.bundleId(category: .plugin, module: "analytics")
        public static let push = Environment.bundleId(category: .plugin, module: "push")
        public static let thirdParty = Environment.bundleId(category: .plugin, module: "thirdparty")
    }
}
