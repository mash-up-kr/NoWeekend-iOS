//
//  ProfileViewModel.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import ProfileDomain
import Core
import Combine

public final class ProfileViewModel: ObservableObject {
    @Published public var user: User?
    @Published public var isLoading: Bool = false
    @Published public var currentTheme: Theme = .system
    @Published public var isNotificationsEnabled: Bool = true
    @Published public var language: String = "한국어"
    @Published public var errorMessage: String = ""
    
    private let userUseCase: UserUseCaseProtocol
    
    public init(userUseCase: UserUseCaseProtocol) {
        self.userUseCase = userUseCase
        print("👤 ProfileViewModel 생성 - 생성자 주입 방식")
    }
    
    @MainActor
    public func loadProfile() async {
        isLoading = true
        do {
            let user = try await userUseCase.getCurrentUser()
            self.user = user
            
            if let preferences = user.preferences {
                currentTheme = preferences.theme
                isNotificationsEnabled = preferences.isNotificationsEnabled
                language = preferences.language == "ko" ? "한국어" : "English"
            }
        } catch {
            print("Error loading profile: \(error)")
            self.user = User(id: "temp", name: "나희", email: "nahee@noweekend.com")
        }
        isLoading = false
    }
    
    @MainActor
    public func updateTheme(_ theme: Theme) async {
        currentTheme = theme
        await updatePreferences()
    }
    
    @MainActor
    public func toggleNotifications() async {
        isNotificationsEnabled.toggle()
        await updatePreferences()
    }
    
    private func updatePreferences() async {
        let preferences = UserPreferences(
            theme: currentTheme,
            isNotificationsEnabled: isNotificationsEnabled,
            language: language == "한국어" ? "ko" : "en"
        )
        
        do {
            try await userUseCase.updateUserPreferences(preferences)
        } catch {
            print("Error updating preferences: \(error)")
        }
    }
}
