//
//  OnboardingFeatureAssembly.swift
//  OnboardingFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DIContainer
import Foundation
import OnboardingDomain
import Swinject

public struct OnboardingFeatureAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("🚪 OnboardingFeatureAssembly 등록 시작")
        
        // UseCase만 등록
        container.register(OnboardingUseCaseProtocol.self) { resolver in
            print("📋 OnboardingUseCase 생성 (Feature)")
            let repository = resolver.resolve(OnboardingRepositoryProtocol.self)!
            return OnboardingUseCase(onboardingRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ OnboardingFeatureAssembly 등록 완료")
    }
}
