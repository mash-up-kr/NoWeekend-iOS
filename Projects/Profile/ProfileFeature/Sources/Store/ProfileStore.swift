//
//  ProfileStore.swift
//  ProfileFeature
//
//  Created by SiJongKim on 7/11/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Combine
import Foundation
import ProfileDomain

public final class ProfileStore: ObservableObject {
    
    @Published public private(set) var state = ProfileState()
    
    private let effectSubject = PassthroughSubject<ProfileEffect, Never>()
    public var effect: AnyPublisher<ProfileEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(getUserProfileUseCase: GetUserProfileUseCaseProtocol) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }
    
    public func send(_ action: ProfileAction) {
        switch action {
        case .loadUserProfile:
            handleLoadUserProfile()
            
        case .userProfileLoaded(let profile):
            handleUserProfileLoaded(profile)
            
        case .loadUserProfileFailed(let error):
            handleLoadUserProfileFailed(error)
            
        case .clearErrors:
            handleClearErrors()
            
        case .resetState:
            handleResetState()
        }
    }
    
    // MARK: - Action Handlers
    
    private func handleLoadUserProfile() {
        guard !state.isLoading && state.userProfile == nil else {
            print("⚠️ ProfileStore: 이미 로딩 중이거나 데이터가 존재함")
            return
        }
        
        state.isLoading = true
        state.generalError = nil
        
        Task { @MainActor in
            do {
                let profile = try await getUserProfileUseCase.execute()
                send(.userProfileLoaded(profile))
            } catch {
                send(.loadUserProfileFailed(error))
            }
        }
    }
    
    private func handleUserProfileLoaded(_ profile: UserProfile) {
        print("✅ userProfile loaded: \(profile)")
        state.isLoading = false
        state.userProfile = profile
    }
    
    private func handleLoadUserProfileFailed(_ error: Error) {
        state.isLoading = false
        state.generalError = error.localizedDescription
        effectSubject.send(.showErrorMessage("프로필 정보를 불러오는데 실패했습니다"))
    }
    
    private func handleClearErrors() {
        state.generalError = nil
    }
    
    private func handleResetState() {
        state = ProfileState()
    }
    
    public var remainingLeaveText: String {
        guard let profile = state.userProfile else {
            return "15"
        }
        
        return String(profile.remainingAnnualLeave)
    }
    
    public var usedLeaveText: String {
        guard state.userProfile != nil else {
            return "0"
        }
        
        // TODO: 추후 실제 사용한 연차 API가 추가되면 교체
        return "0"
    }
    
    private func formatLeaveHours(_ hours: Double) -> String {
    let days = Int(hours) / 8
    let remainingHours = Int(hours) % 8

    if remainingHours == 0 {
        return "\(days)"
    } else if remainingHours == 4 {
        return "\(days).5"
    } else {
        return "\(days)"
    }
}
    
    public var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "v. \(version)"
        }
        return "v. 1.0"
    }
    
    public var displayNickname: String {
        guard let profile = state.userProfile else {
            return ""
        }
        
        if let nickname = profile.nickname, !nickname.isEmpty {
            return nickname
        } else {
            return profile.name
        }
    }
    
    public var providerDisplayText: String {
        guard let profile = state.userProfile else {
            return "애플 계정"
        }
        
        switch profile.providerType {
        case .google:
            return "구글 계정"
        case .apple:
            return "애플 계정"
        @unknown default:
            return "애플 계정"
        }
    }
    
    // MARK: - Public Interface
    
    public func loadInitialData() {
        send(.loadUserProfile)
    }
    
    public func clearErrors() {
        send(.clearErrors)
    }
    
    public func resetState() {
        send(.resetState)
    }
    
    // MARK: - 편의 프로퍼티
    
    public var hasData: Bool {
        state.userProfile != nil
    }
    
    public var isLoadingOrHasData: Bool {
        state.isLoading || hasData
    }
}
