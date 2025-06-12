//
//  AppStore.swift
//  App
//
//  Created by SiJongKim on 6/12/25.
//

import Foundation
import Combine
import Login
import Domain

@MainActor
public final class AppStore: ObservableObject {
    @Published public private(set) var currentState: AppState = .loading
    @Published public private(set) var currentUser: LoginUser?
    
    public init() {
        // 자동로그인 체크 로직
    }
    
    public func send(_ intent: AppIntent) {
        switch intent {
        case .checkAutoLogin:
            // 자동 로그인 로직
            
        case .loginSucceeded(let user):
            currentUser = user
            
            if user.isOnboardingCompleted {
                currentState = .main
            } else {
                currentState = .onboarding
            }
            
        case .onboardingCompleted:
            currentState = .main
            
        case .logout:
            // 로그아웃 로직
        }
    }
}
