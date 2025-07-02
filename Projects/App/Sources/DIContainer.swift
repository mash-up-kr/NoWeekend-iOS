//
//  DIContainer.swift
//  App
//
//  Created by 김시종 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import UIKit
import Login
import LoginInterface
import Onboarding
import Domain
import UseCase
import ServiceInterface
import RepositoryInterface
import Network
import Utils
import Repository

@MainActor
public final class DIContainer {
    public static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Login Store
    public func makeLoginStore() -> LoginStore {
        let networkService = NetworkService(
            baseURL: "https://noweekend.store",
            headers: ["Content-Type": "application/json"]
        )
        
        let authRepository = AuthRepositoryImpl(networkService: networkService)
        let googleAuthService = GoogleAuthService()
        let appleAuthService = AppleAuthService()
        let viewControllerProvider = ViewControllerProvider()
        
        let googleLoginUseCase = GoogleLoginUseCase(
            authRepository: authRepository,
            googleAuthService: googleAuthService,
            viewControllerProvider: viewControllerProvider
        )
        
        let appleLoginUseCase = AppleLoginUseCase(
            authRepository: authRepository,
            appleAuthService: appleAuthService
        )
        
        let authUseCase = AuthUseCase(
            googleAuthService: googleAuthService,
            appleAuthService: appleAuthService
        )
        
        return LoginStore(
            loginWithGoogleUseCase: googleLoginUseCase,
            loginWithAppleUseCase: appleLoginUseCase,
            authUseCase: authUseCase
        )
    }
    
    // MARK: - Onboarding Store
    public func makeOnboardingStore() -> OnboardingStore {
        let networkService = NetworkService(
            baseURL: "https://noweekend.store",
            headers: ["Content-Type": "application/json"]
        )
        
        // Repository 생성
        let onboardingDataSource = OnboardingNetworkDataSource(networkService: networkService)
        let onboardingRepository = OnboardingRepository(dataSource: onboardingDataSource)
        
        // UseCase들 생성
        let saveProfileUseCase = SaveProfileUseCase(repository: onboardingRepository)
        let saveLeaveUseCase = SaveLeaveUseCase(repository: onboardingRepository)
        let saveTagsUseCase = SaveTagsUseCase(repository: onboardingRepository)
        let validateNicknameUseCase = ValidateNicknameUseCase()
        let validateBirthDateUseCase = ValidateBirthDateUseCase()
        let validateRemainingDaysUseCase = ValidateRemainingDaysUseCase()
        
        return OnboardingStore(
            saveProfileUseCase: saveProfileUseCase,
            saveLeaveUseCase: saveLeaveUseCase,
            saveTagsUseCase: saveTagsUseCase,
            validateNicknameUseCase: validateNicknameUseCase,
            validateBirthDateUseCase: validateBirthDateUseCase,
            validateRemainingDaysUseCase: validateRemainingDaysUseCase
        )
    }
}
