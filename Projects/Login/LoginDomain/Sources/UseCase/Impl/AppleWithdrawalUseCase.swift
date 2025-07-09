//
//  AppleWithdrawalUseCase.swift
//  LoginDomain
//
//  Created by SiJongKim on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public final class AppleWithdrawalUseCase: AppleWithdrawalUseCaseInterface {
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
    public func execute() async throws {
        
        do {
            let identityToken = try await appleAuthService.requestWithdrawalAuthorization()
            
            guard !identityToken.isEmpty else {
                throw LoginError.invalidAppleCredential
            }
            
            try await authRepository.withdrawAppleAccount(identityToken: identityToken)
            
            print("✅ Apple 계정 회원탈퇴 완료")
        } catch {
            if let loginError = error as? LoginError {
                switch loginError {
                case .appleSignInCancelled:
                    print("   - 원인: 사용자가 재인증을 취소함")
                    throw LoginError.withdrawalCancelled
                case .appleSignInFailed, .invalidAppleCredential:
                    print("   - 원인: Apple 재인증 실패")
                    throw LoginError.withdrawalFailed(error)
                default:
                    throw LoginError.withdrawalFailed(error)
                }
            } else {
                throw LoginError.withdrawalFailed(error)
            }
        }
    }
}
