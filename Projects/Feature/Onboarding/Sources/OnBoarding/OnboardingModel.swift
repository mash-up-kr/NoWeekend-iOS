//
//  OnboradingState.swift
//  Onboarding
//
//  Created by SiJongKim on 6/23/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - Model (State)
public struct OnboardingState: Equatable {
    public var currentStep: Int = 0
    public var nickname: String = ""
    public var birthDate: String = ""
    
    public var remainingDays: String = ""
    public var remainingHours: String = ""
    public var totalDays: String = "15"
    public var selectedTags: Set<String> = []
    
    public var nicknameError: String? = nil
    public var birthDateError: String? = nil
    public var remainingDaysError: String? = nil
    public var remainingHoursError: String? = nil
    public var totalDaysError: String? = nil
    
    public var isLoading: Bool = false
    public var isNextButtonEnabled: Bool = false
    public var isOnboardingCompleted: Bool = false
    
    public static let totalSteps = 3
    
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
        return remainingDaysError != nil || remainingHoursError != nil || totalDaysError != nil
    }
    
    public init() {}
}

// MARK: - Intent (Actions)
public enum OnboardingIntent {
    case goToNextStep
    case goToPreviousStep
    case updateNickname(String)
    case updateBirthDate(String)
    case updateRemainingDays(String)
    case updateRemainingHours(String)
    case updateTotalDays(String)
    case toggleTag(String)
    case validateCurrentStep
    case completeOnboarding
}
