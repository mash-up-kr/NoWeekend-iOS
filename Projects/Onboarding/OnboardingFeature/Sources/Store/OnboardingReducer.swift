//
//  OnboardingReducer.swift (수정된 버전)
//  Onboarding
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct OnboardingReducer {
    
    public init() {}
    
    public func reduce(_ state: OnboardingState, _ action: OnboardingAction) -> OnboardingState {
        var newState = state
        
        switch action {
        case .nicknameUpdated(let nickname, let errorMessage):
            newState.nickname = nickname
            newState.nicknameError = errorMessage
            
        case .birthDateUpdated(let birthDate, let errorMessage):
            newState.birthDate = birthDate
            newState.birthDateError = errorMessage
            
        case .remainingDaysUpdated(let days, let errorMessage):
            newState.remainingDays = days
            newState.remainingDaysError = errorMessage
            
        case .stepValidationRequested:
            newState.isNextButtonEnabled = newState.isCurrentStepValid && !newState.isLoading
            
        case .halfDayToggled(let hasHalfDay):
            newState.hasHalfDay = hasHalfDay
            newState.remainingHours = hasHalfDay ? "4" : "0"
            
        case .tagToggled(let tag):
            if newState.selectedTags.contains(tag) {
                newState.selectedTags.remove(tag)
            } else {
                newState.selectedTags.insert(tag)
            }
            
            newState.isNextButtonEnabled = newState.isCurrentStepValid && !newState.isLoading
            
        case .stepValidated(let isValid):
            newState.isNextButtonEnabled = isValid && !newState.isLoading
            
            // MARK: - Network Actions
        case .saveProfileStarted, .saveLeaveStarted, .saveTagsStarted:
            newState.isLoading = true
            newState.isNextButtonEnabled = false
            
        case .saveProfileSucceeded, .saveLeaveSucceeded, .saveTagsSucceeded:
            newState.isLoading = false
            if newState.isLastStep {
                newState.isOnboardingCompleted = true
            } else {
                newState.currentStep += 1
            }
            
        case .saveProfileFailed:
            newState.isLoading = false
            newState.nicknameError = "프로필 저장에 실패했습니다. 다시 시도해주세요."
            
        case .saveLeaveFailed:
            newState.isLoading = false
            newState.remainingDaysError = "연차 정보 저장에 실패했습니다. 다시 시도해주세요."
            
        case .saveTagsFailed:
            newState.isLoading = false
            
        case .stepChanged(let step):
            newState.currentStep = max(0, step)
            newState.isNextButtonEnabled = newState.isCurrentStepValid && !newState.isLoading
            
        case .onboardingCompleted:
            newState.isOnboardingCompleted = true
        }
        
        return newState
    }
}

public struct OnboardingIntentMapper {
    
    public init() {}
    
    public func mapIntent(_ intent: OnboardingIntent, currentState: OnboardingState) -> [OnboardingAction] {
        switch intent {
        case .goToNextStep:
            switch currentState.currentStep {
            case 0:
                return [.saveProfileStarted]
            case 1:
                return [.saveLeaveStarted]
            case 2:
                return [.saveTagsStarted]
            default:
                return []
            }
            
        case .goToPreviousStep:
            let previousStep = max(0, currentState.currentStep - 1)
            return [.stepChanged(previousStep)]
            
        case .updateNickname:
            return []
            
        case .updateBirthDate:
            return []
            
        case .updateRemainingDays:
            return []
            
        case .updateHasHalfDay(let hasHalfDay):
            return [.halfDayToggled(hasHalfDay), .stepValidationRequested]
            
        case .toggleTag(let tag):
            return [.tagToggled(tag), .stepValidationRequested]
            
        case .validateCurrentStep:
            return [.stepValidated(currentState.isCurrentStepValid)]
            
        case .retryCurrentStep:
            switch currentState.currentStep {
            case 0:
                return [.saveProfileStarted]
            case 1:
                return [.saveLeaveStarted]
            case 2:
                return [.saveTagsStarted]
            default:
                return []
            }
        }
    }
}
