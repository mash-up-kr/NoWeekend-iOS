//
//  OnboardingUseCase.swift
//  OnboardingDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol OnboardingUseCaseProtocol {
    func completeOnboarding(credentials: OnboardingCredentials) async throws -> OnboardingToken
    func skipOnboarding() async throws
    func refreshToken() async throws -> OnboardingToken
    func isOnboardingCompleted() -> Bool
}

public class OnboardingUseCase: OnboardingUseCaseProtocol {
    private let onboardingRepository: OnboardingRepositoryProtocol
    
    public init(onboardingRepository: OnboardingRepositoryProtocol) {
        self.onboardingRepository = onboardingRepository
    }
    
    public func completeOnboarding(credentials: OnboardingCredentials) async throws -> OnboardingToken {
        return try await onboardingRepository.completeOnboarding(credentials: credentials)
    }
    
    public func skipOnboarding() async throws {
        try await onboardingRepository.skipOnboarding()
    }
    
    public func refreshToken() async throws -> OnboardingToken {
        return try await onboardingRepository.refreshToken()
    }
    
    public func isOnboardingCompleted() -> Bool {
        return onboardingRepository.isOnboardingCompleted()
    }
}
