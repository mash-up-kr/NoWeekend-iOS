//
//  AuthUseCase.swift
//  UseCase
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation

public final class AuthUseCase: @preconcurrency AuthUseCaseInterface {
    private let googleAuthService: GoogleAuthServiceInterface
    private let appleAuthService: AppleAuthServiceInterface
    
    public nonisolated init(
        googleAuthService: GoogleAuthServiceInterface,
        appleAuthService: AppleAuthServiceInterface
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
    }
    
    @MainActor
    public func signOutGoogle() {
        googleAuthService.signOut()
    }
    
    @MainActor
    public func signOutApple() {
        print("Apple Sign-In signed out")
    }
}
