//
//  OnboardingAssembly.swift
//  OnboardingData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Swinject
import OnboardingDomain
import Core

public struct OnboardingAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("🚪 OnboardingAssembly 등록 시작")
        
        // Repository 등록
        container.register(OnboardingRepositoryProtocol.self) { _ in
            print("📦 OnboardingRepository 생성")
            return OnboardingRepositoryImpl()
        }.inObjectScope(.container)
        
        // UseCase 등록
        container.register(OnboardingUseCaseProtocol.self) { resolver in
            print("📋 OnboardingUseCase 생성")
            let repository = resolver.resolve(OnboardingRepositoryProtocol.self)!
            return OnboardingUseCase(onboardingRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ OnboardingAssembly 등록 완료")
    }
}
