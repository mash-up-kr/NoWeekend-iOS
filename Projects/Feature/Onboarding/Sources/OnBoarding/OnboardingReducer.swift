//
//  OnboardingReducer.swift
//  Onboarding
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct OnboardingReducer {
    
    public init() {}
    
    public func reduce(
        _ state: OnboardingState,
        _ action: OnboardingAction
    ) -> OnboardingState {
        var newState = state
        
        switch action {
            // MARK: - Input Actions
        case .nicknameChanged(let nickname):
            let filteredNickname = String(nickname.prefix(6))
            newState.nickname = filteredNickname
            
        case .birthDateChanged(let birthDate):
            let filteredBirthDate = String(birthDate.filter { $0.isNumber }.prefix(8))
            newState.birthDate = filteredBirthDate
            
        case .remainingDaysChanged(let days):
            let filteredDays = String(days.filter { $0.isNumber }.prefix(2))
            newState.remainingDays = filteredDays
            
        case .halfDayToggled(let hasHalfDay):
            newState.hasHalfDay = hasHalfDay
            newState.remainingHours = hasHalfDay ? "4" : "0"
            
        case .tagToggled(let tag):
            if newState.selectedTags.contains(tag) {
                newState.selectedTags.remove(tag)
            } else {
                newState.selectedTags.insert(tag)
            }
            
            // MARK: - Validation Actions
        case .nicknameValidated(let result):
            newState.nicknameError = result.errorMessage
            
        case .birthDateValidated(let result):
            newState.birthDateError = result.errorMessage
            
        case .remainingDaysValidated(let result):
            newState.remainingDaysError = result.errorMessage
            
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
            
        case .saveProfileFailed(let error):
            newState.isLoading = false
            newState.nicknameError = "프로필 저장에 실패했습니다. 다시 시도해주세요."
            
        case .saveLeaveSuccaFailed(let error):
            newState.isLoading = false
            newState.remainingDaysError = "연차 정보 저장에 실패했습니다. 다시 시도해주세요."
            
        case .saveTagsFailed(let error):
            newState.isLoading = false
            
            // MARK: - Navigation Actions
        case .stepChanged(let step):
            newState.currentStep = max(0, step)
            
        case .onboardingCompleted:
            newState.isOnboardingCompleted = true
        }
        
        newState.isNextButtonEnabled = newState.isCurrentStepValid && !newState.isLoading
        
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
            
        case .updateNickname(let nickname):
            return [.nicknameChanged(nickname)]
            
        case .updateBirthDate(let birthDate):
            return [.birthDateChanged(birthDate)]
            
        case .updateRemainingDays(let days):
            return [.remainingDaysChanged(days)]
            
        case .updateHasHalfDay(let hasHalfDay):
            return [.halfDayToggled(hasHalfDay)]
            
        case .toggleTag(let tag):
            return [.tagToggled(tag)]
            
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
