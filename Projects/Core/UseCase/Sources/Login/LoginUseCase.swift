//
//  LoginUseCase.swift
//  Network
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain
import RepositoryInterface

public protocol LoginUseCaseInterface {
    func loginWithGoogle(accessToken: String, name: String?) async throws -> LoginUser
    func loginWithApple(identityToken: String, name: String?) async throws -> LoginUser
    func signOut()
}

public final class LoginUseCaseImpl: LoginUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    
    public init(authRepository: AuthRepositoryInterface) {
        self.authRepository = authRepository
    }
    
    public func loginWithGoogle(accessToken: String, name: String?) async throws -> LoginUser {
        return try await authRepository.loginWithGoogle(accessToken: accessToken, name: name)
    }
    
    public func loginWithApple(identityToken: String, name: String?) async throws -> LoginUser {
        return try await authRepository.loginWithApple(identityToken: identityToken, name: name)
    }
    
    public func signOut() {
        // 토큰 삭제, 로컬 상태 초기화 등
    }
}
