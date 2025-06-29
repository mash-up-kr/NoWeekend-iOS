//
//  AuthUseCase.swift
//  UseCase
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation
import ServiceInterface
import LoginInterface

public final class AuthUseCase: @preconcurrency AuthUseCaseInterface {
    private let googleAuthService: GoogleAuthServiceInterface
    
    public init(googleAuthService: GoogleAuthServiceInterface) {
        self.googleAuthService = googleAuthService
    }
    
    @MainActor
    public func signOut() {
        googleAuthService.signOut()
    }
}
