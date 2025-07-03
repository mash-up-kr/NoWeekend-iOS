//
//  AuthUseCaseProtocol.swift
//  OnboardingDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol AuthUseCaseProtocol {
    func login(credentials: AuthCredentials) async throws -> AuthToken
    func logout() async throws
    func refreshToken() async throws -> AuthToken
    func isLoggedIn() -> Bool
}

public class AuthUseCase: AuthUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    public init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    public func login(credentials: AuthCredentials) async throws -> AuthToken {
        return try await authRepository.login(credentials: credentials)
    }
    
    public func logout() async throws {
        try await authRepository.logout()
    }
    
    public func refreshToken() async throws -> AuthToken {
        return try await authRepository.refreshToken()
    }
    
    public func isLoggedIn() -> Bool {
        return authRepository.isLoggedIn()
    }
}
