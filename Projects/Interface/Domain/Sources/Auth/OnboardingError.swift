//
//  OnboardingError.swift
//  Domain
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation


public enum OnboardingError: Error, LocalizedError {
    case profileSaveFailed(String)
    case leaveSaveFailed(String)
    case tagsSaveFailed(String)
    case networkError(String)
    
    public var errorDescription: String? {
        switch self {
        case .profileSaveFailed(let message):
            return "프로필 저장 실패: \(message)"
        case .leaveSaveFailed(let message):
            return "연차 정보 저장 실패: \(message)"
        case .tagsSaveFailed(let message):
            return "태그 저장 실패: \(message)"
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        }
    }
}
