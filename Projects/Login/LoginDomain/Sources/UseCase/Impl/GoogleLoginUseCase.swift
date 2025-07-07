//
//  GoogleLoginUseCase.swift
//  LoginDomain
//
//  Created by SiJongKim on 6/11/25.
//

import UIKit
import Foundation
import Utils

@MainActor
public final class GoogleLoginUseCase: GoogleLoginUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    private let googleAuthService: GoogleAuthServiceInterface
    private let viewControllerProvider: ViewControllerProviderInterface
    
    public init(
        authRepository: AuthRepositoryInterface,
        googleAuthService: GoogleAuthServiceInterface,
        viewControllerProvider: ViewControllerProviderInterface
    ) {
        self.authRepository = authRepository
        self.googleAuthService = googleAuthService
        self.viewControllerProvider = viewControllerProvider
    }
    
    public func execute() async throws -> LoginUser {
        guard let presentingViewController = viewControllerProvider.getCurrentPresentingViewController() else {
            throw LoginError.noPresentingViewController
        }
        
        if presentingViewController.view.window == nil {
        }
        
        do {
            let signInResult = try await googleAuthService.signIn(
                presentingViewController: presentingViewController
            )
            
            // ✅ accessToken 유효성 체크
            guard !signInResult.accessToken.isEmpty else {
                throw LoginError.authenticationFailed(
                    NSError(domain: "GoogleSignIn", code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Google 인증 토큰을 받을 수 없습니다."])
                )
            }
            
            let user = try await authRepository.loginWithGoogle(
                authorizationCode: signInResult.accessToken,
                name: nil
            )
            
            return user
            
        } catch {
            if let loginError = error as? LoginError {
                switch loginError {
                case .registrationRequired:
                    // 회원가입이 필요한 경우 - 재인증하여 signInResult 획득
                    let signInResult = try await googleAuthService.signIn(
                        presentingViewController: presentingViewController
                    )
                    
                    // ✅ 재인증 후에도 토큰 유효성 체크
                    guard !signInResult.accessToken.isEmpty else {
                        throw LoginError.authenticationFailed(
                            NSError(domain: "GoogleSignIn", code: -1,
                                   userInfo: [NSLocalizedDescriptionKey: "Google 재인증 토큰을 받을 수 없습니다."])
                        )
                    }
                    
                    guard let profileName = signInResult.name, !profileName.isEmpty else {
                        throw LoginError.nameNotAvailable
                    }
                    
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
