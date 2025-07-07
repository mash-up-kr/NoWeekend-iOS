//
//  GoogleLoginUseCase.swift
//  LoginDomain
//
//  Created by SiJongKim on 6/11/25.
//

import UIKit
import Foundation
import Utils

public final class GoogleLoginUseCase: GoogleLoginUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    private let googleAuthService: GoogleAuthServiceInterface
    private let viewControllerProvider: ViewControllerProviderInterface
    
    public nonisolated init(
        authRepository: AuthRepositoryInterface,
        googleAuthService: GoogleAuthServiceInterface,
        viewControllerProvider: ViewControllerProviderInterface
    ) {
        self.authRepository = authRepository
        self.googleAuthService = googleAuthService
        self.viewControllerProvider = viewControllerProvider
    }
    
    @MainActor
    public func execute() async throws -> LoginUser {
        guard let presentingViewController = viewControllerProvider.getCurrentPresentingViewController() else {
            throw LoginError.noPresentingViewController
        }
        
        do {
            // 1단계: Google 인증
            let signInResult = try await googleAuthService.signIn(
                presentingViewController: presentingViewController
            )
            
            guard !signInResult.accessToken.isEmpty else {
                throw LoginError.authenticationFailed(
                    NSError(domain: "GoogleSignIn", code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Google 인증 토큰을 받을 수 없습니다."])
                )
            }
            
            // 2단계: 로그인 시도 (name 없이 먼저 시도)
            let user = try await authRepository.loginWithGoogle(
                authorizationCode: signInResult.accessToken,
                name: nil
            )
            
            return user
            
        } catch {
            if let loginError = error as? LoginError {
                switch loginError {
                case .registrationRequired:
                    // exists: false인 경우 - 이름 포함해서 재시도
                    let signInResult = try await googleAuthService.signIn(
                        presentingViewController: presentingViewController
                    )
                    
                    guard !signInResult.accessToken.isEmpty else {
                        throw LoginError.authenticationFailed(
                            NSError(domain: "GoogleSignIn", code: -1,
                                   userInfo: [NSLocalizedDescriptionKey: "Google 재인증 토큰을 받을 수 없습니다."])
                        )
                    }
                    
                    guard let profileName = signInResult.name, !profileName.isEmpty else {
                        throw LoginError.nameNotAvailable
                    }
                    
                    // 3단계: 회원가입 시도 (이름 포함)
                    let user = try await authRepository.loginWithGoogle(
                        authorizationCode: signInResult.accessToken,
                        name: profileName
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
