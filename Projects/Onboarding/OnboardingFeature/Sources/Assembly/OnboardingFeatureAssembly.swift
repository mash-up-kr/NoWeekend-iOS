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

public class OnboardingFeatureAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        
        // MARK: - Domain Layer: Save UseCases 등록
        container.register(SaveProfileUseCaseInterface.self) { resolver in
            let repository = resolver.resolve(OnboardingRepositoryInterface.self)!
            return SaveProfileUseCase(repository: repository)
        }.inObjectScope(.container)
        
        container.register(SaveLeaveUseCaseInterface.self) { resolver in
            let repository = resolver.resolve(OnboardingRepositoryInterface.self)!
            return SaveLeaveUseCase(repository: repository)
        }.inObjectScope(.container)
        
        container.register(SaveTagsUseCaseInterface.self) { resolver in
            let repository = resolver.resolve(OnboardingRepositoryInterface.self)!
            return SaveTagsUseCase(repository: repository)
        }.inObjectScope(.container)
        
        // MARK: - Domain Layer: Validation UseCases 등록
        container.register(ValidateNicknameUseCaseInterface.self) { _ in
            ValidateNicknameUseCase()
        }.inObjectScope(.container)
        
        container.register(ValidateBirthDateUseCaseInterface.self) { _ in
            ValidateBirthDateUseCase()
        }.inObjectScope(.container)
        
        container.register(ValidateRemainingDaysUseCaseInterface.self) { _ in
            ValidateRemainingDaysUseCase()
        }.inObjectScope(.container)
        
        // MARK: - Feature Layer: OnboardingStore 등록
        container.register(OnboardingStore.self) { resolver in
            let saveProfileUseCase = resolver.resolve(SaveProfileUseCaseInterface.self)!
            let saveLeaveUseCase = resolver.resolve(SaveLeaveUseCaseInterface.self)!
            let saveTagsUseCase = resolver.resolve(SaveTagsUseCaseInterface.self)!
            let validateNicknameUseCase = resolver.resolve(ValidateNicknameUseCaseInterface.self)!
            let validateBirthDateUseCase = resolver.resolve(ValidateBirthDateUseCaseInterface.self)!
            let validateRemainingDaysUseCase = resolver.resolve(ValidateRemainingDaysUseCaseInterface.self)!
            
            return OnboardingStore(
                saveProfileUseCase: saveProfileUseCase,
                saveLeaveUseCase: saveLeaveUseCase,
                saveTagsUseCase: saveTagsUseCase,
                validateNicknameUseCase: validateNicknameUseCase,
                validateBirthDateUseCase: validateBirthDateUseCase,
                validateRemainingDaysUseCase: validateRemainingDaysUseCase
            )
        }.inObjectScope(.transient)
        
        print("✅ OnboardingFeature Assembly 등록 완료 (Domain + Feature)")
    }
}
