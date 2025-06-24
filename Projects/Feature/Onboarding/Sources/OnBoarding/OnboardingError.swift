//
//  OnboardingErrir.swift
//  Onboarding
//
//  Created by SiJongKim on 6/24/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum OnboardingError: Equatable, CaseIterable {
    // 닉네임 관련 에러
    case nicknameEmpty
    case nicknameTooLong
    case nicknameInvalid
    
    // 연차 관련 에러
    case invalidNumber
    case totalDaysMustBePositive
    case remainingDaysExceedTotal
    case hoursExceedLimit
    case hoursNotAllowedWhenSameDays
    case remainingVacationExceedsTotal
    
    public var message: String {
        switch self {
        // 닉네임 에러
        case .nicknameEmpty:
            return "닉네임을 입력해주세요"
        case .nicknameTooLong:
            return "닉네임은 10자 이하로 입력해주세요"
        case .nicknameInvalid:
            return "유효한 닉네임을 입력해주세요"
            
        // 연차 에러
        case .invalidNumber:
            return "올바른 숫자를 입력해주세요"
        case .totalDaysMustBePositive:
            return "0보다 큰 숫자를 입력해주세요"
        case .remainingDaysExceedTotal:
            return "남은 연차 일수가 전체 연차보다 클 수 없습니다"
        case .hoursExceedLimit:
            return "8시간 미만으로 입력해주세요"
        case .hoursNotAllowedWhenSameDays:
            return "전체 연차와 같은 일수일 때는 시간을 입력할 수 없습니다"
        case .remainingVacationExceedsTotal:
            return "남은 연차가 전체 연차를 초과할 수 없습니다"
        }
    }
    
    public var priority: Int {
        switch self {
        // 에러 우선 순위
        case .totalDaysMustBePositive:
            return 1
        case .invalidNumber:
            return 2
        case .remainingDaysExceedTotal:
            return 3
        case .hoursExceedLimit:
            return 4
        case .hoursNotAllowedWhenSameDays:
            return 5
        case .remainingVacationExceedsTotal:
            return 6
        case .nicknameEmpty, .nicknameTooLong, .nicknameInvalid:
            return 10
        }
    }
}
