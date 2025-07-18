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
            navigationBar
            
            ScrollView {
                VStack(spacing: 0) {
                    titleSection
                    currentStepContent
                    Spacer(minLength: 200)
                }
                .padding(.horizontal, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .contentShape(Rectangle())
            .onTapGesture { dismissKeyboard() }
            
            bottomButton
        }
        .navigationBarHidden(true)
        .background(DS.Colors.Background.normal)
        .onAppear { store.send(.viewDidLoad) }
        .onReceive(store.effect, perform: handleEffect)
    }
    
    // MARK: - View Components
    
    private var navigationBar: some View {
        CustomNavigationBar(
            type: .backOnly,
            onBackTapped: { store.send(.backButtonTapped) }
        )
    }
    
    private var titleSection: some View {
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
    }
    
    @ViewBuilder
    private var currentStepContent: some View {
        switch store.state.currentStep {
        case .vacationDaysInput:
            VacationDaysInputView(
                vacationDays: store.state.vacationDays,
                remainingAnnualLeave: homeStore.state.remainingAnnualLeave,
                errorMessage: store.state.errorMessage,
                onDaysChanged: { store.send(.vacationDaysInputChanged($0)) }
            )
            
        case .vacationTypeSelection:
            VacationTypeSelectionView(
                selectedTypes: store.state.selectedVacationTypes,
                onTypeToggled: { store.send(.vacationTypeToggled($0)) }
            )
            .padding(.horizontal, -24)
        }
    }
    
    private var bottomButton: some View {
        NWButton.black(
            store.state.currentStep == .vacationTypeSelection ? "휴가 바삭하게 굽기" : "다음",
            size: .xl,
            isEnabled: store.state.isNextButtonEnabled,
            action: { store.send(.nextButtonTapped) }
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
        .background(DS.Colors.Background.normal)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Actions
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func handleEffect(_ effect: VacationBakingEffect) {
        switch effect {
        case .navigateToHome:
            let result = VacationBakingResult(
                days: store.state.vacationDays,
                selectedTypes: store.state.selectedVacationTypes
            )
            homeStore.send(.vacationBakingCompleted(result))
            dismiss()
        case .showError(let message):
            print("Error: \(message)")
        }
    }
}

#Preview {
    VacationBakingView()
}
