//
//  AppState.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import OnboardingDomain
import DIContainer

@MainActor
@Observable
public class AppState {
    public var isOnboardingCompleted: Bool = false
    public var isLoading: Bool = true
    
    public init() {
        print("🌐 AppState 초기화")
    }
    
    public func checkOnboardingStatus() {
        print("🔍 온보딩 상태 확인")
        
        // Repository에서 온보딩 완료 상태 확인
        let repository = DIContainer.shared.resolve(OnboardingRepositoryProtocol.self)
        isOnboardingCompleted = repository.isOnboardingCompleted()
        isLoading = false
        
        print("✅ 온보딩 상태 확인 완료: \(isOnboardingCompleted)")
    }
    
    public func completeOnboarding() {
        print("✅ 온보딩 완료 처리")
        isOnboardingCompleted = true
    }
}
