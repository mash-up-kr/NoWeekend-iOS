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
    private let realOnboardingDatabase: [OnboardingCredentials] = [
        OnboardingCredentials(email: "user1@company.com", password: "password123"),
        OnboardingCredentials(email: "user2@company.com", password: "password456"),
        OnboardingCredentials(email: "admin@company.com", password: "admin123")
    ]
    
    private var isCompleted: Bool = false
    
    public init() {
        print("🚪 OnboardingRepositoryImpl 생성")
    }
    
    public func completeOnboarding(credentials: OnboardingCredentials) async throws -> OnboardingToken {
        print("🚪 온보딩 완료 API 호출: \(credentials.email)")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1초
        
        // 간단한 인증 검증
        guard realOnboardingDatabase.contains(where: { $0.email == credentials.email && $0.password == credentials.password }) else {
            throw OnboardingError.invalidCredentials
        }
        
        isCompleted = true
        
        let token = OnboardingToken(
            accessToken: "mock_access_token_\(UUID().uuidString)",
            refreshToken: "mock_refresh_token_\(UUID().uuidString)",
            expiresAt: Date().addingTimeInterval(3600) // 1시간 후 만료
        )
        
        print("✅ 온보딩 완료 성공")
        return token
    }
    
    public func skipOnboarding() async throws {
        print("⏭️ 온보딩 건너뛰기")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
        
        isCompleted = true
        print("✅ 온보딩 건너뛰기 완료")
    }
    
    public func refreshToken() async throws -> OnboardingToken {
        print("🔄 토큰 갱신 API 호출")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
        
        let token = OnboardingToken(
            accessToken: "refreshed_access_token_\(UUID().uuidString)",
            refreshToken: "refreshed_refresh_token_\(UUID().uuidString)",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        print("✅ 토큰 갱신 완료")
        return token
    }
    
    public func isOnboardingCompleted() -> Bool {
        return isCompleted
    }
}

// MARK: - OnboardingData Module Configuration
public enum OnboardingDataModule {
    public static func configure() {
        print("🚪 OnboardingData 모듈 설정 시작")
        
        let assembly = OnboardingAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ OnboardingData 모듈 설정 완료")
    }
}
