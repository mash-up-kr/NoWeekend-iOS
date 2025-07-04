//
//  AppDependencyConfiguration.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import HomeFeature
import ProfileFeature
import CalendarFeature
import OnboardingFeature
import DataBridge

enum AppDependencyConfiguration {
    static func configure() {
        print("🔧 DI Container 앱 설정 시작")
        
        // 1. DataBridge를 통해 모든 Data Repository 등록
        DataBridge.initialize()
        
        // 2. Feature 모듈들이 자체 UseCase 등록
        HomeFeatureModule.registerUseCases()
        ProfileFeatureModule.registerUseCases()
        CalendarFeatureModule.registerUseCases()
        OnboardingFeatureModule.registerUseCases()
        
        print("✅ DI Container 설정 완료")
    }
}
