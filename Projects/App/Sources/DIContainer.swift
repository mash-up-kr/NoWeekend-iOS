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
    
    public func makeLoginStore() -> LoginStore {
        let networkService = NetworkService(
            baseURL: "https://api.noweekend.com",
            headers: ["Content-Type": "application/json"]
        )
        
        let authRepository = AuthRepositoryImpl(networkService: networkService)
        let googleAuthService = GoogleAuthService()
        let viewControllerProvider = ViewControllerProvider()
        
        let googleLoginUseCase = GoogleLoginUseCase(
            authRepository: authRepository,
            googleAuthService: googleAuthService,
            viewControllerProvider: viewControllerProvider
        )
        
        let authUseCase = AuthUseCase(googleAuthService: googleAuthService)
        
        return LoginStore(
            loginWithGoogleUseCase: googleLoginUseCase,
            authUseCase: authUseCase
        )
    }
}
