//
//  File.swift
//  Network
//
//  Created by SiJongKim on 6/11/25.
//

import UIKit
import Domain
import RepositoryInterface
import ServiceInterface
import LoginInterface
import NetworkInterface
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
            // ViewController가 화면에 표시되지 않음
        }
        
        do {
            let signInResult = try await googleAuthService.signIn(
                presentingViewController: presentingViewController
            )
            
            let user = try await authRepository.loginWithGoogle(
                accessToken: signInResult.accessToken,
                name: nil
            )
            
            return user
            
        } catch {
            if isUnauthorizedError(error) {
                guard let profileName = signInResult?.name, !profileName.isEmpty else {
                    throw LoginError.nameNotAvailable
                }
                let user = try await authRepository.loginWithGoogle(
                    accessToken: signInResult?.accessToken ?? "",
                    name: profileName
                )
                return user
            } else {
                throw LoginError.authenticationFailed(error)
            }
        }
    }
    
    // signInResult를 저장하여 재사용
    private var signInResult: GoogleSignInResult?
    
    private func isUnauthorizedError(_ error: Error) -> Bool {
        let result = if let networkError = error as? NetworkError,
           case .serverError(let message) = networkError {
            message.contains("401") || message.contains("Unauthorized")
        } else {
            false
        }
        return result
    }
}
