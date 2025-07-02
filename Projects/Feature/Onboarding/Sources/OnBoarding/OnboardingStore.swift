//
//  OnboardingStore.swift
//  Onboarding
//
//  Created by SiJongKim on 6/23/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Combine
import UseCase
import Domain
import Repository

public class OnboardingStore: ObservableObject {
    
    // MARK: - Published State
    @Published public var state = OnboardingState()
    
    // MARK: - Dependencies
    private let reducer = OnboardingReducer()
    private let intentMapper = OnboardingIntentMapper()
    
    private let saveProfileUseCase: SaveProfileUseCaseInterface
    private let saveLeaveUseCase: SaveLeaveUseCaseInterface
    private let saveTagsUseCase: SaveTagsUseCaseInterface
    private let validateNicknameUseCase: ValidateNicknameUseCaseInterface
    private let validateBirthDateUseCase: ValidateBirthDateUseCaseInterface
    private let validateRemainingDaysUseCase: ValidateRemainingDaysUseCaseInterface
    
    // MARK: - Initialization
    public init(
        saveProfileUseCase: SaveProfileUseCaseInterface,
        saveLeaveUseCase: SaveLeaveUseCaseInterface,
        saveTagsUseCase: SaveTagsUseCaseInterface,
        validateNicknameUseCase: ValidateNicknameUseCaseInterface,
        validateBirthDateUseCase: ValidateBirthDateUseCaseInterface,
        validateRemainingDaysUseCase: ValidateRemainingDaysUseCaseInterface
    ) {
        self.saveProfileUseCase = saveProfileUseCase
        self.saveLeaveUseCase = saveLeaveUseCase
        self.saveTagsUseCase = saveTagsUseCase
        self.validateNicknameUseCase = validateNicknameUseCase
        self.validateBirthDateUseCase = validateBirthDateUseCase
        self.validateRemainingDaysUseCase = validateRemainingDaysUseCase
        
        // 초기 상태 검증
        DispatchQueue.main.async {
            self.send(.validateCurrentStep)
        }
    }
    
    // MARK: - Intent Processing
    public func send(_ intent: OnboardingIntent) {
        let actions = intentMapper.mapIntent(intent, currentState: state)
        
        for action in actions {
            processAction(action)
        }
        
        performAdditionalValidation(for: intent)
    }
    
    // MARK: - Action Processing
    private func processAction(_ action: OnboardingAction) {
        DispatchQueue.main.async {
            self.state = self.reducer.reduce(self.state, action)
        }
        
        handleSideEffects(for: action)
    }
    
    // MARK: - Side Effects
    private func handleSideEffects(for action: OnboardingAction) {
        switch action {
        case .saveProfileStarted:
            Task { @MainActor in
                do {
                    try await saveProfileUseCase.execute(
                        nickname: state.nickname,
                        birthDate: state.birthDate
                    )
                    processAction(.saveProfileSucceeded)
                } catch {
                    processAction(.saveProfileFailed(error))
                }
            }
            
        case .saveLeaveStarted:
            Task { @MainActor in
                do {
                    let days = Int(state.remainingDays) ?? 0
                    let hours = Int(state.remainingHours) ?? 0
                    
                    try await saveLeaveUseCase.execute(days: days, hours: hours)
                    processAction(.saveLeaveSucceeded)
                } catch {
                    processAction(.saveLeaveSuccaFailed(error))
                }
            }
            
        case .saveTagsStarted:
            Task { @MainActor in
                do {
                    let tags = Array(state.selectedTags)
                    try await saveTagsUseCase.execute(tags: tags)
                    processAction(.saveTagsSucceeded)
                } catch {
                    processAction(.saveTagsFailed(error))
                }
            }
            
        default:
            break
        }
    }
    
    // MARK: - Additional Validation
    private func performAdditionalValidation(for intent: OnboardingIntent) {
        switch intent {
        case .updateNickname(_):
            let result = validateNicknameUseCase.execute(state.nickname)
            processAction(.nicknameValidated(result))
            
        case .updateBirthDate(_):
            let result = validateBirthDateUseCase.execute(state.birthDate)
            processAction(.birthDateValidated(result))
            
        case .updateRemainingDays(_):
            let result = validateRemainingDaysUseCase.execute(state.remainingDays)
            processAction(.remainingDaysValidated(result))
            
        case .updateHasHalfDay(_), .toggleTag(_):
            processAction(.stepValidated(state.isCurrentStepValid))
            
        default:
            break
        }
    }
}
