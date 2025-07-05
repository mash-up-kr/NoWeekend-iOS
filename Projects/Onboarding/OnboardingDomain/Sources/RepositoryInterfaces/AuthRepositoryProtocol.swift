//
//  AuthRepositoryProtocol.swift
//  OnboardingDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol AuthRepositoryProtocol {
    func login(credentials: AuthCredentials) async throws -> AuthToken
    func logout() async throws
    func refreshToken() async throws -> AuthToken
    func isLoggedIn() -> Bool
}
