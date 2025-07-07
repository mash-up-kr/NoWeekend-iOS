//
//  AuthUseCase.swift
//  UseCase
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation

public final class AuthUseCase: AuthUseCaseInterface {
    private let googleAuthService: GoogleAuthServiceInterface
    private let appleAuthService: AppleAuthServiceInterface
    
    public init(
        googleAuthService: GoogleAuthServiceInterface,
        appleAuthService: AppleAuthServiceInterface
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
    }
    
    public func signOutGoogle() {
        googleAuthService.signOut()
    }
    
    public func signOutApple() {
        print("Apple Sign-In signed out")
    }
}
