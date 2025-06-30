//
//  OnboardingStore.swift
//  Onboarding
//
//  Created by SiJongKim on 6/23/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Combine

public class OnboardingStore: ObservableObject {
    @Published public var state = OnboardingState()
    
    public init() {
        updateButtonEnabledState()
    }
    
    public func send(_ intent: OnboardingIntent) {
        switch intent {
        case .goToNextStep:
            handleGoToNextStep()
            
        case .goToPreviousStep:
            handleGoToPreviousStep()
            
        case .updateNickname(let nickname):
            handleUpdateNickname(nickname)
            
        case .updateBirthDate(let birthDate):
            handleUpdateBirthDate(birthDate)
            
        case .updateRemainingDays(let days):
            handleUpdateRemainingDays(days)
            
        case .updateHasHalfDay(let value):
            state.hasHalfDay = value
            state.remainingHours = value ? "4" : "0"
            updateButtonEnabledState()
            
        case .toggleTag(let tag):
            handleToggleTag(tag)
            
        case .validateCurrentStep:
            updateButtonEnabledState()
            
        case .completeOnboarding:
            handleCompleteOnboarding()
        }
    }
    
    // MARK: - Private Methods
    private func handleGoToNextStep() {
        guard state.isNextButtonEnabled else { return }
        
        if state.isLastStep {
            handleCompleteOnboarding()
        } else {
            state.currentStep += 1
            updateButtonEnabledState()
        }
    }
    
    private func handleGoToPreviousStep() {
        guard state.currentStep > 0 else { return }
        state.currentStep -= 1
        updateButtonEnabledState()
    }
    
    private func handleUpdateNickname(_ nickname: String) {
        state.nickname = nickname
        validateNickname()
        updateButtonEnabledState()
    }
    
    private func handleUpdateBirthDate(_ birthDate: String) {
        // 8자리 숫자로 제한
        let filteredBirthDate = String(birthDate.filter { $0.isNumber }.prefix(8))
        state.birthDate = filteredBirthDate
        validateBirthDate()
        updateButtonEnabledState()
    }
    
    private func handleUpdateRemainingDays(_ days: String) {
        let filteredDays = String(days.filter { $0.isNumber }.prefix(2))
        state.remainingDays = filteredDays
        validateRemainingDays()
        updateButtonEnabledState()
    }
    
    private func handleToggleTag(_ tag: String) {
        if state.selectedTags.contains(tag) {
            state.selectedTags.remove(tag)
        } else {
            state.selectedTags.insert(tag)
        }
        updateButtonEnabledState()
    }
    
    private func handleCompleteOnboarding() {
        state.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.state.isLoading = false
            self?.state.isOnboardingCompleted = true
        }
    }
    
    // MARK: - Validation Methods
    private func validateNickname() {
        if state.nickname.isEmpty {
            state.nicknameError = "닉네임을 입력해주세요"
        } else if state.nickname.count > 10 {
            state.nicknameError = "닉네임은 10자 이하로 입력해주세요"
        } else if state.nickname.trimmingCharacters(in: .whitespaces).isEmpty {
            state.nicknameError = "유효한 닉네임을 입력해주세요"
        } else {
            state.nicknameError = nil
        }
    }
    
    private func validateBirthDate() {
        if state.birthDate.isEmpty {
            state.birthDateError = "생년월일을 입력해주세요"
        } else if state.birthDate.count != 8 {
            state.birthDateError = "생년월일은 8자리로 입력해주세요"
        } else if state.birthDate.filter({ !$0.isNumber }).count > 0 {
            state.birthDateError = "유효한 생년월일을 입력해주세요"
        } else {
            state.birthDateError = nil
        }
    }
    
    // MARK: - 개별 필드 검증 메서드들
    private func validateRemainingDays() {
        state.remainingDaysError = nil
        if state.remainingDays.isEmpty {
            return
        }
        guard let _ = Int(state.remainingDays) else {
            state.remainingDaysError = "올바른 숫자를 입력해주세요"
            return
        }
    }
    
    private func updateButtonEnabledState() {
        switch state.currentStep {
        case 0:
            state.isNextButtonEnabled = !state.nickname.isEmpty &&
                                       !state.birthDate.isEmpty &&
                                       state.nicknameError == nil &&
                                       state.birthDateError == nil
            
        case 1:
            let hasRemainingDays = !state.remainingDays.isEmpty
            let hasNoError = state.hasVacationError == false
            state.isNextButtonEnabled = hasRemainingDays && hasNoError
            
        case 2:
            state.isNextButtonEnabled = state.selectedTags.count >= 3
            
        default:
            state.isNextButtonEnabled = false
        }
    }
}
