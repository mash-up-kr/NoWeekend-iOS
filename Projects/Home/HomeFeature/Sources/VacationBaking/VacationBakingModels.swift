//
//  VacationBakingModels.swift
//  HomeFeature
//
//  Created by 김나희 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

// MARK: - VacationBaking State

struct VacationBakingState: Equatable {
    var currentStep: VacationBakingStep = .vacationDaysInput
    var vacationDays: Int = 0
    var selectedVacationTypes: Set<VacationType> = []
    var isNextButtonEnabled: Bool = false
    var isCompleted: Bool = false
    var errorMessage: String? = nil
}

// MARK: - VacationBaking Intent

enum VacationBakingIntent {
    case viewDidLoad
    case vacationDaysInputChanged(String)
    case vacationTypeToggled(VacationType)
    case nextButtonTapped
    case backButtonTapped
    case completeButtonTapped
}

// MARK: - VacationBaking Effect

enum VacationBakingEffect {
    case navigateToHome
    case showError(String)
}

// MARK: - VacationBaking Models

enum VacationBakingStep: CaseIterable {
    case vacationDaysInput
    case vacationTypeSelection
    
    var title: String {
        switch self {
        case .vacationDaysInput:
            return "휴가로 사용할\n연차 일수를 입력해주세요."
        case .vacationTypeSelection:
            return "딱 맞는 연차를 찾기 위해\n정보를 참고할게요"
        }
    }
    
    func subtitle(remainingDays: Int) -> String {
        switch self {
        case .vacationDaysInput:
            return "남은 연차 \(remainingDays)일"
        case .vacationTypeSelection:
            return "나의 표현하는 단어 선택"
        }
    }
}

enum VacationType: String, CaseIterable {
    case planning = "계획형"
    case activeVacation = "즉흥 자유형"
    case rest = "휴식"
    case selfImprovement = "자기계발"
    case housework = "야외 활동"
    case eating = "집콕"
    case meal = "음식"
    case watching = "관광"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - VacationBaking Result

struct VacationBakingResult {
    let days: Int
    let selectedTypes: Set<VacationType>
    
    // API 요청을 위한 매핑
    var travelStyle: String {
        if selectedTypes.contains(.planning) {
            return "PLANNER"
        } else if selectedTypes.contains(.activeVacation) {
            return "SPONTANEOUS"
        }
        return "PLANNER" // 기본값
    }
    
    var activityType: String {
        if selectedTypes.contains(.housework) {
            return "OUTDOOR"
        } else if selectedTypes.contains(.eating) {
            return "AT_HOME"
        }
        return "OUTDOOR" // 기본값
    }
    
    var restPreference: String {
        if selectedTypes.contains(.rest) {
            return "REST"
        } else if selectedTypes.contains(.selfImprovement) {
            return "SELF_DEVELOPMENT"
        }
        return "REST" // 기본값
    }
    
    var leisurePreference: String {
        if selectedTypes.contains(.meal) {
            return "FOOD"
        } else if selectedTypes.contains(.watching) {
            return "TOURISM"
        }
        return "TOURISM" // 기본값
    }
}

// MARK: - VacationBaking Status

enum VacationBakingStatus: Equatable {
    case none           // 휴가 추천 없음
    case requesting     // 휴가 추천 요청 중
    case ready          // 휴가 추천 완료
    case failed         // 휴가 추천 실패
    
    var titleText: String {
        switch self {
        case .none:
            "온도를 식히는 휴식 어떠세요?"
        case .requesting:
            "최대 2분 이내 확인할 수 있어요"
        case .ready:
            "토스트가 노릇하게 구워졌어요"
        case .failed:
            "휴가 굽기에 실패했어요"
        }
    }
    
    var buttonText: String {
        switch self {
        case .none:
            return "최대 7일 휴가 굽기"
        case .requesting:
            return "휴가 굽는중"
        case .ready:
            return "휴가 쓸래말래?"
        case .failed:
            return "다시 굽기"
        }
    }
    
    var isButtonEnabled: Bool {
        switch self {
        case .none, .ready, .failed:
            return true
        case .requesting:
            return false
        }
    }
}
