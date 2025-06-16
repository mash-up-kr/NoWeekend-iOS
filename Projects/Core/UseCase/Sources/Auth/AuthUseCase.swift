//
//  AuthUseCase.swift
//  UseCase
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation
import ServiceInterface
import LoginInterface

public final class AuthUseCase: AuthUseCaseInterface {
    private let googleAuthService: GoogleAuthServiceInterface
    
    public init(googleAuthService: GoogleAuthServiceInterface) {
        self.googleAuthService = googleAuthService
    }
    
    public func signOut() {
        googleAuthService.signOut()
    }
}
