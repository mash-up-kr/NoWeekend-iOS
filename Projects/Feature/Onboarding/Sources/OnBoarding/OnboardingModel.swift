//
//  OnboradingState.swift
//  Onboarding
//
//  Created by SiJongKim on 6/23/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Combine
import Domain

// MARK: - Model (State)
public struct OnboardingState: Equatable {
    public var currentStep: Int = 0
    public var isOnboardingCompleted: Bool = false
    
    // MARK: - Form Data
    public var nickname: String = ""
    public var birthDate: String = ""
    public var remainingDays: String = ""
    public var remainingHours: String = ""
    public var hasHalfDay: Bool = false
    public var selectedTags: Set<String> = []
    
    // MARK: - Validation State
    public var nicknameError: String? = nil
    public var birthDateError: String? = nil
    public var remainingDaysError: String? = nil
    
    // MARK: - UI State
    public var isLoading: Bool = false
    public var isNextButtonEnabled: Bool = false
    
    // MARK: - Constants
    public static let totalSteps = 3
    
    // MARK: - Computed Properties
    public var isLastStep: Bool {
        return currentStep >= Self.totalSteps - 1
    }
    
    public var displayRemainingDays: String {
        return remainingDays.isEmpty ? "0" : remainingDays
    }
    
    public var displayRemainingHours: String {
        return remainingHours.isEmpty ? "0" : remainingHours
    }
    
    public var hasVacationError: Bool {
        return remainingDaysError != nil
    }
    
    public var isCurrentStepValid: Bool {
        switch currentStep {
        case 0:
            return !nickname.isEmpty &&
                   !birthDate.isEmpty &&
                   nicknameError == nil &&
                   birthDateError == nil
        case 1:
            return !remainingDays.isEmpty && !hasVacationError
        case 2:
            return selectedTags.count >= 3
        default:
            return false
        }
    }
    
    public init() {}
}

// MARK: - Intent (Actions)
public enum OnboardingAction {
    // Input Actions
    case nicknameChanged(String)
    case birthDateChanged(String)
    case remainingDaysChanged(String)
    case halfDayToggled(Bool)
    case tagToggled(String)
    
    // Validation Actions
    case nicknameValidated(ValidationResult)
    case birthDateValidated(ValidationResult)
    case remainingDaysValidated(ValidationResult)
    case stepValidated(Bool)
    
    // Network Actions
    case saveProfileStarted
    case saveProfileSucceeded
    case saveProfileFailed(Error)
    
    case saveLeaveStarted
    case saveLeaveSucceeded
    case saveLeaveSuccaFailed(Error)
    
    case saveTagsStarted
    case saveTagsSucceeded
    case saveTagsFailed(Error)
    
    // Navigation Actions
    case stepChanged(Int)
    case onboardingCompleted
}

public enum OnboardingIntent {
    // Navigation Intents
    case goToNextStep
    case goToPreviousStep
    
    // Input Intents
    case updateNickname(String)
    case updateBirthDate(String)
    case updateRemainingDays(String)
    case updateHasHalfDay(Bool)
    case toggleTag(String)
    
    // System Intents
    case validateCurrentStep
    case retryCurrentStep
}

public enum OnboardingSideEffect {
    case saveProfile(nickname: String, birthDate: String)
    case saveLeave(days: Int, hours: Int)
    case saveTags([String])
    case validateNickname(String)
    case validateBirthDate(String)
    case validateRemainingDays(String)
    case navigateToNextStep
    case showError(String)
    case completeOnboarding
}
