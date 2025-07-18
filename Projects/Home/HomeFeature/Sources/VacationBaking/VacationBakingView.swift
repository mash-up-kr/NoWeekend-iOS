//
//  VacationBakingView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct VacationBakingView: View {
    @StateObject private var store = VacationBakingStore()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coordinator: HomeCoordinator
    @EnvironmentObject private var homeStore: HomeStore
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                type: .backOnly,
                onBackTapped: {
                    store.send(.backButtonTapped)
                }
            )
            
            VStack(spacing: 0) {
                // 타이틀 영역
                VStack(spacing: 8) {
                    Text(store.state.currentStep.title)
                        .font(.heading3)
                        .foregroundColor(DS.Colors.Text.netural)
                        .multilineTextAlignment(.center)
                    
                    Text(store.state.currentStep.subtitle(remainingDays: homeStore.state.remainingAnnualLeave))
                        .font(.body2)
                        .foregroundColor(DS.Colors.Text.body)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 32)
                .padding(.bottom, 48)
                
                // 단계별 콘텐츠
                Group {
                    switch store.state.currentStep {
                    case .vacationDaysInput:
                        VacationDaysInputView(
                            vacationDays: store.state.vacationDays,
                            remainingAnnualLeave: homeStore.state.remainingAnnualLeave,
                            errorMessage: store.state.errorMessage,
                            onDaysChanged: { inputText in
                                store.send(.vacationDaysInputChanged(inputText))
                            }
                        )
                        
                    case .vacationTypeSelection:
                        VacationTypeSelectionView(
                            selectedTypes: store.state.selectedVacationTypes,
                            onTypeToggled: { type in
                                store.send(.vacationTypeToggled(type))
                            }
                        )
                        .padding(.horizontal, -24)
                    }
                }
                
                Spacer()
                
                // 하단 버튼
                NWButton.black(
                    store.state.currentStep == .vacationTypeSelection ? "휴가 바삭하게 굽기" : "다음",
                    size: .xl,
                    isEnabled: store.state.isNextButtonEnabled,
                    action: {
                        store.send(.nextButtonTapped)
                    }
                )
                .frame(maxWidth: .infinity)
                .padding(.bottom, 34)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
        .background(DS.Colors.Background.normal)
        .onAppear {
            store.send(.viewDidLoad)
        }
        .onReceive(store.effect) { effect in
            switch effect {
            case .navigateToHome:
                let result = VacationBakingResult(
                    days: store.state.vacationDays,
                    selectedTypes: store.state.selectedVacationTypes
                )
                homeStore.send(.vacationBakingCompleted(result))
                dismiss()
            case .showError(let message):
                // 에러 처리
                print("Error: \(message)")
            }
        }
    }
}

#Preview {
    VacationBakingView()
}
