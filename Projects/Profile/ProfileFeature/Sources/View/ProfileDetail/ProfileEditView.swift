//
//  ProfileEditView.swift (정리된 버전)
//  ProfileFeature
//
//  Created by SiJongKim on 7/4/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Combine
import DesignSystem
import DIContainer
import SwiftUI

public struct ProfileEditView: View {
    @EnvironmentObject private var coordinator: ProfileCoordinator
    @ObservedObject private var editStore: ProfileEditStore
    
    @State private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.editStore = DIContainer.shared.resolve(ProfileEditStore.self)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            profileEditForm
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            editStore.initializeIfNeeded()
        }
        .onReceive(editStore.effect) { effect in
            handleEffect(effect)
        }
    }
    
    // MARK: - UI Components
    
    private var navigationBar: some View {
        CustomNavigationBar(
            type: .backWithLabelAndSave("계정 설정"),
            onBackTapped: {
                coordinator.pop()
            },
            onSaveTapped: {
                editStore.saveProfile()
                coordinator.pop()
            }
        )
        .padding(.bottom, 48)
    }
    
    private var profileEditForm: some View {
        NWUserInputView(
            title: "정보를 작성해 주세요",
            subtitle: "언제든 변경할 수 있어요"
        ) {
            VStack(spacing: 24) {
                nicknameSection
                birthDateSection
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
        }
    }
    
    private var nicknameSection: some View {
        NWNicknameInputSection(
            nickname: Binding(
                get: { editStore.state.nickname },
                set: { editStore.updateNickname($0) }
            ),
            nicknameError: editStore.state.nicknameError
        )
    }
    
    private var birthDateSection: some View {
        NWBirthDateInputSection(
            birthDate: Binding(
                get: { editStore.state.birthDate },
                set: { editStore.updateBirthDate($0) }
            ),
            birthDateError: editStore.state.birthDateError
        )
    }
    
    // MARK: - Effect Handling (순수 UI 반응만)
    
    private func handleEffect(_ effect: ProfileEditEffect) {
        switch effect {
        case .showSuccessMessage(let message):
            // TODO: Toast 메시지 표시
            print("✅ Success: \(message)")
            
        case .showErrorMessage(let message):
            // TODO: Error Toast 표시
            print("❌ Error: \(message)")
            
        case .navigateBack:
            coordinator.pop()
        }
    }
}
