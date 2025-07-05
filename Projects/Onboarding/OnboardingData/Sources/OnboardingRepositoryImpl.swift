//
//  OnboardingRepositoryImpl.swift
//  OnboardingData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import OnboardingDomain
import Core

public final class OnboardingRepositoryImpl: OnboardingRepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let onboardingCompletedKey = "onboarding_completed"
    private let userTokenKey = "user_token"
    
    public init() {
        print("🚪 OnboardingRepositoryImpl 생성")
    }
    
    public func completeOnboarding(credentials: OnboardingCredentials) async throws -> OnboardingToken {
        print("🚪 온보딩 완료 API 호출: \(credentials.email)")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let token = OnboardingToken(
            accessToken: "access_token_\(UUID().uuidString)",
            refreshToken: "refresh_token_\(UUID().uuidString)",
            expiresAt: Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date()
        )
        
        // 온보딩 완료 상태 저장
        userDefaults.set(true, forKey: onboardingCompletedKey)
        
        // 토큰 저장 (실제로는 Keychain 사용 권장)
        if let tokenData = try? JSONEncoder().encode(token) {
            userDefaults.set(tokenData, forKey: userTokenKey)
        }
        
        print("✅ 온보딩 완료 및 토큰 저장 성공")
        return token
    }
    
    public func skipOnboarding() async throws {
        print("⏭️ 온보딩 건너뛰기")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // 온보딩 완료 상태만 저장 (토큰은 없음)
        userDefaults.set(true, forKey: onboardingCompletedKey)
        
        print("✅ 온보딩 건너뛰기 완료")
    }
    
    public func refreshToken() async throws -> OnboardingToken {
        print("🔄 토큰 갱신 API 호출")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let newToken = OnboardingToken(
            accessToken: "new_access_token_\(UUID().uuidString)",
            refreshToken: "new_refresh_token_\(UUID().uuidString)",
            expiresAt: Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date()
        )
        
        // 새 토큰 저장
        if let tokenData = try? JSONEncoder().encode(newToken) {
            userDefaults.set(tokenData, forKey: userTokenKey)
        }
        
        print("✅ 토큰 갱신 완료")
        return newToken
    }
    
    public func isOnboardingCompleted() -> Bool {
        let isCompleted = userDefaults.bool(forKey: onboardingCompletedKey)
        print("🚪 온보딩 완료 상태 확인: \(isCompleted)")
        return isCompleted
    }
}
