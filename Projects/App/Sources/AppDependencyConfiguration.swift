//
//  AppDependencyConfiguration.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core
import Swinject
import HomeFeature
import ProfileFeature
import CalendarFeature

enum AppDependencyConfiguration {
    static func configure() {
        print("🔧 DI Container 앱 설정 시작")
        
        DataConfiguration.configure()
        registerFeatureAssemblies()
        
        print("✅ DI Container 방식 설정 완료")
    }
    
    private static func registerFeatureAssemblies() {
        print("📦 Feature Assembly 등록 시작")
         let assemblies: [Assembly] = [
            HomeFeatureAssembly(),
            ProfileFeatureAssembly(),
            CalendarFeatureAssembly(),
        ]
        
        DIContainer.shared.registerAssembly(assembly: assemblies)
        
        print("✅ 모든 Feature Assembly 등록 완료")
    }
}
