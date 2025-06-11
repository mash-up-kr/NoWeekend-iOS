//
//  File.swift
//  Network
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import Domain
import RepositoryInterface
import LoginInterface

public final class LoginWithGoogleUseCase: LoginWithGoogleUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    
    public init(authRepository: AuthRepositoryInterface) {
        self.authRepository = authRepository
    }
    
    public func execute(accessToken: String, name: String?) async throws -> LoginUser {
        return try await authRepository.loginWithGoogle(accessToken: accessToken, name: name)
    }
}
