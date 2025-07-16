//
//  OnboardingView.swift (수정된 버전)
//  Calendar
//
//  Created by SiJongKim on 7/4/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DesignSystem
import DIContainer
import SwiftUI

public struct OnboardingView: View {
    @ObservedObject private var store: OnboardingStore
    
    public init() {
        self.store = DIContainer.shared.resolve(OnboardingStore.self)
    }
    
    public init(store: OnboardingStore) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            CustomNavigationBar.conditionalBack(
                title: "\(store.state.currentStep + 1)/\(OnboardingState.totalSteps)",
                showBackButton: store.state.currentStep > 0,
                onBackTapped: {
                    store.send(.goToPreviousStep)
                }
            )
            .padding(.bottom, 48)
            
            TabView(selection: $store.state.currentStep) {
                nicknameStepView
                    .tag(0)
                
                experienceStepView
                    .tag(1)
                
                scheduleStepView
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: store.state.currentStep)
            .dismissKeyboardOnTap()
            .highPriorityGesture(
                DragGesture()
                    .onChanged { _ in }
            )
            
            bottomButtonView
                .padding(.horizontal, 24)
        }
        .background(DS.Colors.Background.normal)
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Step Views
    
    private var nicknameStepView: some View {
        NWUserInputView(
            title: "정보를 작성해 주세요",
            subtitle: "언제든 변경할 수 있어요"
        ) {
            VStack(spacing: 24) {
                NWNicknameInputSection(
                    nickname: Binding(
                        get: { store.state.nickname },
                        set: { newValue in
                            store.send(.updateNickname(newValue))
                        }
                    ),
                    nicknameError: store.state.nicknameError
                )
                
                NWBirthDateInputSection(
                    birthDate: Binding(
                        get: { store.state.birthDate },
                        set: { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            store.send(.updateBirthDate(filtered))
                        }
                    ),
                    birthDateError: store.state.birthDate.count >= 8 ? store.state.birthDateError : nil
                )
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
        }
    }
    
    private var experienceStepView: some View {
        VStack(spacing: 32) {
            NWUserInputView(
                title: "올해 남은 연차를 알려주세요"
            ) {
                VStack {
                    NWRemainingDaysDisplaySection(
                        displayDays: store.state.displayRemainingDays,
                        displayHours: store.state.displayRemainingHours
                    )
                }
                
                VStack {
                    NWRemainingDaysInputSection(
                        remainingDays: Binding(
                            get: { store.state.remainingDays },
                            set: { store.send(.updateRemainingDays($0)) }
                        ),
                        remainingDaysError: store.state.remainingDaysError,
                        hasHalfDay: Binding(
                            get: { store.state.hasHalfDay },
                            set: { store.send(.updateHasHalfDay($0)) }
                        )
                    )
                }
                
                Spacer()
                
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var scheduleStepView: some View {
        NWUserInputView(
            title: "자주하는 일정을 알려주세요",
            subtitle: "할일 등록을 AI에게 추천받을 수 있어요"
        ) {
            VStack {
                NWTagSelectionView.onboardingTags(
                    selectedTags: store.state.selectedTags,
                    onTagToggle: { tag in
                        store.send(.toggleTag(tag))
                    }
                )
            }
            .padding(.top, 40)
        }
    }
    
    private var bottomButtonView: some View {
        VStack(spacing: 0) {
            NWButton(
                title: buttonTitle,
                variant: .black,
                isEnabled: store.state.isNextButtonEnabled && !store.state.isLoading
            ) {
                store.send(.goToNextStep)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var buttonTitle: String {
        switch store.state.currentStep {
        case 0, 1:
            return "다음"
        case 2:
            if store.state.isNextButtonEnabled {
                return "시작하기"
            } else {
                return "3개 이상 선택해주세요"
            }
        default:
            return "다음"
        }
    }
}
