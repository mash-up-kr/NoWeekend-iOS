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
            
        case .updateRemainingDays(let days):
            handleUpdateRemainingDays(days)
            
        case .updateRemainingHours(let hours):
            handleUpdateRemainingHours(hours)
            
        case .updateTotalDays(let totalDays):
            handleUpdateTotalDays(totalDays)
            
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
    
    private func handleUpdateRemainingDays(_ days: String) {
        let filteredDays = String(days.filter { $0.isNumber }.prefix(2))
        state.remainingDays = filteredDays
        
        validateRemainingDays()
        updateButtonEnabledState()
    }
    
    private func handleUpdateRemainingHours(_ hours: String) {
        let filteredHours = String(hours.filter { $0.isNumber }.prefix(2))
        state.remainingHours = filteredHours
        
        validateRemainingHours()
        updateButtonEnabledState()
    }
    
    private func handleUpdateTotalDays(_ totalDays: String) {
        let filteredTotalDays = String(totalDays.filter { $0.isNumber }.prefix(2))
        state.totalDays = filteredTotalDays
        
        validateTotalDays()
        validateRemainingDays()
        validateRemainingHours()
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
    
    // MARK: - 개별 필드 검증 메서드들
    private func validateRemainingDays() {
        state.remainingDaysError = nil
        
        if state.remainingDays.isEmpty {
            return
        }
        
        guard let remainingDays = Int(state.remainingDays) else {
            state.remainingDaysError = "올바른 숫자를 입력해주세요"
            return
        }
        
        if !state.totalDays.isEmpty,
           let totalDays = Int(state.totalDays),
           remainingDays > totalDays {
            state.remainingDaysError = "남은 연차 일수가 전체 연차보다 클 수 없습니다"
            return
        }
        
        if !state.remainingHours.isEmpty && !state.totalDays.isEmpty {
            validateTotalVacationTime()
        }
    }

    private func validateRemainingHours() {
        state.remainingHoursError = nil
        
        if state.remainingHours.isEmpty {
            return
        }
        
        guard let remainingHours = Int(state.remainingHours) else {
            state.remainingHoursError = "올바른 숫자를 입력해주세요"
            return
        }
        
        if remainingHours >= 9 {
            state.remainingHoursError = "8시간 미만으로 입력해주세요"
            return
        }
        
        if !state.remainingDays.isEmpty && !state.totalDays.isEmpty {
            validateTotalVacationTime()
        }
    }

    private func validateTotalDays() {
        state.totalDaysError = nil
        
        if state.totalDays.isEmpty {
            // 빈 값일 때는 에러 표시하지 않음
            return
        }
        
        guard let totalDays = Int(state.totalDays) else {
            state.totalDaysError = "올바른 숫자를 입력해주세요"
            return
        }
        
        if totalDays <= 0 {
            state.totalDaysError = "0보다 큰 숫자를 입력해주세요"
            return
        }
    }
    
    // MARK: - 전체 연차 시간 검증 (모든 값이 입력되었을 때만 실행)
    private func validateTotalVacationTime() {
        guard let remainingDays = Int(state.remainingDays),
              let remainingHours = Int(state.remainingHours),
              let totalDays = Int(state.totalDays) else {
            return
        }
        
        let totalRemainingInHours = remainingDays * 8 + remainingHours
        let totalDaysInHours = totalDays * 8
        
        if totalRemainingInHours > totalDaysInHours {
            // 일수는 같은데 시간 때문에 초과하는 경우
            if remainingDays == totalDays && remainingHours > 0 {
                state.remainingHoursError = "전체 연차와 같은 일수일 때는 시간을 입력할 수 없습니다"
            } else {
                // 시간까지 합쳐서 초과하는 경우
                state.remainingHoursError = "남은 연차가 전체 연차를 초과할 수 없습니다"
            }
        }
    }
    
    private func updateButtonEnabledState() {
        switch state.currentStep {
        case 0:
            state.isNextButtonEnabled = !state.nickname.isEmpty && state.nicknameError == nil
            
        case 1:
            let hasRemainingDays = !state.remainingDays.isEmpty
            let hasRemainingHours = !state.remainingHours.isEmpty
            let hasTotalDays = !state.totalDays.isEmpty
            let hasNoError = state.hasVacationError == false
            
            state.isNextButtonEnabled = hasRemainingDays && hasRemainingHours && hasTotalDays && hasNoError
            
        case 2:
            state.isNextButtonEnabled = state.selectedTags.count >= 3
            
        default:
            state.isNextButtonEnabled = false
        }
    }
}
