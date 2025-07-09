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
import NWNetwork
import DIContainer
import LoginFeature

enum AppDependencyConfiguration {
    static func configure() {
        print("🔧 DI Container 앱 설정 시작")
        
        registerNetworkServices()
        
        DataBridge.initialize()
        
        HomeFeatureModule.registerUseCases()
        ProfileFeatureModule.registerUseCases()
        CalendarFeatureModule.registerUseCases()
        OnboardingFeatureModule.registerUseCases()
        LoginFeatureModule.registerUseCases()  
        
        print("✅ DI Container 설정 완료")
    }
    
    private static func registerNetworkServices() {
        print("🌐 Network Service 등록")
        
        DIContainer.shared.register(NWNetworkServiceProtocol.self) { _ in
            // TODO: 실제 인증 토큰 처리 로직 추가
            let authToken: String? = nil // TODO: UserDefaults나 Keychain에서 가져오기
            return NWNetworkService(authToken: authToken)
        }
        
        print("✅ Network Service 등록 완료")
    }
}
