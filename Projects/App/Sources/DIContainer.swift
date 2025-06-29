//
//  DIContainer.swift
//  App
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Login
import UseCase
import Network
import Repository

@MainActor
public final class DIContainer {
    public static let shared = DIContainer()
    
    public lazy var loginStore: LoginStore = {
        let networkService = NetworkService(
            baseURL: "https://noweekend.store",
            headers: [
                "Content-Type": "application/json"
            ]
        )
        
        let authRepository = AuthRepositoryImpl(networkService: networkService)
        let loginUseCase = LoginUseCaseImpl(authRepository: authRepository)
        let googleAuthService = GoogleAuthService()
        
        return LoginStore(
            loginUseCase: loginUseCase,
            googleAuthService: googleAuthService
        )
    }()
    
    private init() {}
}
