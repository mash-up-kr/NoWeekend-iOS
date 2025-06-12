//
//  AppState.swift
//  App
//
//  Created by SiJongKim on 6/12/25.
//

import Foundation
import Domain


public enum AppState {
    case loading
    case login
    case onboarding
    case main
}

public enum AppIntent {
    case checkAutoLogin
    case loginSucceeded(user: LoginUser)
    case onboardingCompleted
    case logout
}
