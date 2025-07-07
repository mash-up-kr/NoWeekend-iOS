//
//  AppleLoginUseCase.swift
//  LoginDomain
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public final class AppleLoginUseCase: AppleLoginUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    private let appleAuthService: AppleAuthServiceInterface
    
    public nonisolated init(
        authRepository: AuthRepositoryInterface,
        appleAuthService: AppleAuthServiceInterface
    ) {
        self.authRepository = authRepository
        self.appleAuthService = appleAuthService
    }
    
    @MainActor
    public func execute() async throws -> LoginUser {
        let signInResult = try await appleAuthService.signIn()
        
        let fullName = [
            signInResult.fullName?.givenName,
            signInResult.fullName?.familyName
        ].compactMap { $0 }.joined(separator: " ")
        
        let nameToSend = fullName.isEmpty ? nil : fullName
        
        // identityToken을 authorizationCode로 사용
        let authCode = signInResult.identityToken ?? ""
        
        guard !authCode.isEmpty else {
            throw LoginError.authenticationFailed(
                NSError(domain: "AppleSignIn", code: -1,
                       userInfo: [NSLocalizedDescriptionKey: "Apple 인증 토큰을 받을 수 없습니다."])
            )
        }
        
        do {
            // 1단계: 로그인 시도 (name 없이 먼저 시도)
            let user = try await authRepository.loginWithApple(
                authorizationCode: authCode,
                name: nil
            )
            
            return user
            
        } catch {
            if let loginError = error as? LoginError {
                switch loginError {
                case .registrationRequired:
                    // exists: false인 경우 - 이름 포함해서 재시도
                    guard let name = nameToSend, !name.isEmpty else {
                        throw LoginError.nameNotAvailable
                    }
                    
                    // 2단계: 회원가입 시도 (이름 포함)
                    let user = try await authRepository.loginWithApple(
                        authorizationCode: authCode,
                        name: name
                    )
                    
                    return user
                    
                case .authenticationFailed, .noPresentingViewController,
                     .nameNotAvailable, .appleSignInCancelled,
                     .appleSignInFailed, .invalidAppleCredential:
                    throw loginError
                }
            } else {
                throw LoginError.authenticationFailed(error)
            }
        }
    }
}
