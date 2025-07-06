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
        public static let nwnetwork = Environment.bundleId(category: .core, module: "nwnetwork")
        public static let dicontainer = Environment.bundleId(category: .core, module: "dicontainer")
        public static let coordinator = Environment.bundleId(category: .core, module: "coordinator")
    }
    
    public struct Feature {
        public static let tabBar = Environment.bundleId(category: .feature, module: "tabbar")
        public static let home = Environment.bundleId(category: .feature, module: "home")
        public static let calendar = Environment.bundleId(category: .feature, module: "calendar")
        public static let profile = Environment.bundleId(category: .feature, module: "profile")
        public static let onboarding = Environment.bundleId(category: .feature, module: "onboarding")
        public static let login = Environment.bundleId(category: .feature, module: "login")
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
    
    // MARK: - Feature별 모듈들
    public struct Home {
        public static let feature = Environment.bundleId(category: .feature, module: "homefeature")
        public static let domain = Environment.bundleId(category: .domain, module: "homedomain")
        public static let data = Environment.bundleId(category: .data, module: "homedata")
    }
    
    public struct Profile {
        public static let feature = Environment.bundleId(category: .feature, module: "profilefeature")
        public static let domain = Environment.bundleId(category: .domain, module: "profiledomain")
        public static let data = Environment.bundleId(category: .data, module: "profiledata")
    }
    
    public struct Calendar {
        public static let feature = Environment.bundleId(category: .feature, module: "calendarfeature")
        public static let domain = Environment.bundleId(category: .domain, module: "calendardomain")
        public static let data = Environment.bundleId(category: .data, module: "calendardata")
    }
    
    public struct Onboarding {
        public static let feature = Environment.bundleId(category: .feature, module: "onboardingfeature")
        public static let domain = Environment.bundleId(category: .domain, module: "onboardingdomain")
        public static let data = Environment.bundleId(category: .data, module: "onboardingdata")
    }
    
    public struct Login {
        public static let feature = Environment.bundleId(category: .feature, module: "loginfeature")
        public static let domain = Environment.bundleId(category: .domain, module: "logindomain")
        public static let data = Environment.bundleId(category: .data, module: "logindata")
    }
}
