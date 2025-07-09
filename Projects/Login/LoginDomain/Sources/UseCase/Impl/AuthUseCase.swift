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
    private let appleWithdrawalUseCase: AppleWithdrawalUseCaseInterface
    
    public init(
        googleAuthService: GoogleAuthServiceInterface,
        appleAuthService: AppleAuthServiceInterface,
        appleWithdrawalUseCase: AppleWithdrawalUseCaseInterface
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        self.appleWithdrawalUseCase = appleWithdrawalUseCase
    }
    
    // MARK: - 로그아웃 기능
    
    public func signOutGoogle() {
        googleAuthService.signOut()
    }
    
    public func signOutApple() {
        appleAuthService.signOut()
    }
    
    // MARK: - Apple 회원탈퇴 기능
    
    @MainActor
    public func withdrawAppleAccount() async throws {
        try await appleWithdrawalUseCase.execute()
    }
}
