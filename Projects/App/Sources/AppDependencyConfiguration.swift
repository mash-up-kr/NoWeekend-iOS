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

import HomeData
import ProfileData
import CalendarData

enum AppDependencyConfiguration {
    static func configure() {
        print("🔧 DI Container 앱 설정 시작")
        
        // 1. Data 모듈들이 자체 Repository 등록
        HomeDataModule.registerRepositories()
        ProfileDataModule.registerRepositories()
        CalendarDataModule.registerRepositories()
        
        // 2. Feature 모듈들이 자체 UseCase 등록
        HomeFeatureModule.registerUseCases()
        ProfileFeatureModule.registerUseCases()
        CalendarFeatureModule.registerUseCases()
        
        print("✅ DI Container 설정 완료")
    }
}
