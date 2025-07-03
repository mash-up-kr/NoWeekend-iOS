//
//  OnboardingRepositoryProtocol.swift
//  OnboardingDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol OnboardingRepositoryProtocol {
    func completeOnboarding(credentials: OnboardingCredentials) async throws -> OnboardingToken
    func skipOnboarding() async throws
    func refreshToken() async throws -> OnboardingToken
    func isOnboardingCompleted() -> Bool
}
