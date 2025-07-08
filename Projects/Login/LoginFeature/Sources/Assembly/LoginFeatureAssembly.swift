//
//  LoginFeatureAssembly.swift
//  LoginFeature
//
//  Created by SiJongKim on 7/7/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DIContainer
import Foundation
import LoginDomain
import Swinject
import Utils

public struct LoginFeatureAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("🔐 LoginFeatureAssembly 등록 시작")
        
        container.register(AppleLoginUseCaseInterface.self) { resolver in
            let authRepository = resolver.resolve(AuthRepositoryInterface.self)!
            let appleAuthService = resolver.resolve(AppleAuthServiceInterface.self)!
            return AppleLoginUseCase(
                authRepository: authRepository,
                appleAuthService: appleAuthService
            )
        }.inObjectScope(.graph)
        
        container.register(GoogleLoginUseCaseInterface.self) { resolver in
            let authRepository = resolver.resolve(AuthRepositoryInterface.self)!
            let googleAuthService = resolver.resolve(GoogleAuthServiceInterface.self)!
            let viewControllerProvider = resolver.resolve(ViewControllerProviderInterface.self)!
            return GoogleLoginUseCase(
                authRepository: authRepository,
                googleAuthService: googleAuthService,
                viewControllerProvider: viewControllerProvider
            )
        }.inObjectScope(.graph)
        
        container.register(AuthUseCaseInterface.self) { resolver in
            let googleAuthService = resolver.resolve(GoogleAuthServiceInterface.self)!
            let appleAuthService = resolver.resolve(AppleAuthServiceInterface.self)!
            return AuthUseCase(
                googleAuthService: googleAuthService,
                appleAuthService: appleAuthService
            )
        }.inObjectScope(.graph)
        
        container.register(LoginStore.self) { resolver in
            let googleLoginUseCase = resolver.resolve(GoogleLoginUseCaseInterface.self)!
            let appleLoginUseCase = resolver.resolve(AppleLoginUseCaseInterface.self)!
            let authUseCase = resolver.resolve(AuthUseCaseInterface.self)!

            return LoginStore(
                loginWithGoogleUseCase: googleLoginUseCase,
                loginWithAppleUseCase: appleLoginUseCase,
                authUseCase: authUseCase
            )
        }
        .inObjectScope(.graph)
        
        print("✅ LoginFeatureAssembly 등록 완료")
    }
}
