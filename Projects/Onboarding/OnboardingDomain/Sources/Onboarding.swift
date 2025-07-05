//
//  onboarding.swift
//  OnboardingDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct OnboardingCredentials {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct OnboardingToken: Codable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date
    
    public init(accessToken: String, refreshToken: String, expiresAt: Date) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}

public enum OnboardingError: Error, LocalizedError {
    case invalidCredentials
    case networkError
    case tokenExpired
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "이메일 또는 비밀번호가 올바르지 않습니다."
        case .networkError:
            return "네트워크 오류가 발생했습니다."
        case .tokenExpired:
            return "세션이 만료되었습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
