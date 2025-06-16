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
import Common

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
        
        let signInResult = try await googleAuthService.signIn(
            presentingViewController: presentingViewController
        )
        
        do {
            let user = try await authRepository.loginWithGoogle(
                accessToken: signInResult.accessToken,
                name: nil
            )
            return user
            
        } catch {
            if isUnauthorizedError(error) {
                guard let profileName = signInResult.name,
                      !profileName.isEmpty else {
                    throw LoginError.nameNotAvailable
                }
                
                let user = try await authRepository.loginWithGoogle(
                    accessToken: signInResult.accessToken,
                    name: profileName
                )
                return user
            } else {
                throw LoginError.authenticationFailed(error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func isUnauthorizedError(_ error: Error) -> Bool {
        if let networkError = error as? NetworkError,
           case .serverError(let message) = networkError {
            return message.contains("401") || message.contains("Unauthorized")
        }
        return false
    }
}
