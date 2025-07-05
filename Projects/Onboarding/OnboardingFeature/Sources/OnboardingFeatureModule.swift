//
//  OnboardingFeatureModule.swift
//  OnboardingFeature
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import DIContainer
import Swinject
import OnboardingDomain

public enum OnboardingFeatureModule {
    public static func registerUseCases() {
        print("🚪 OnboardingFeature UseCase 등록")
        
        let assembly = OnboardingFeatureAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ OnboardingFeature UseCase 등록 완료")
    }
}
