//
//  ProfileViewModel.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import ProfileDomain
import Core
import Combine

public final class ProfileViewModel: ObservableObject {
    @Dependency private var userUseCase: UserUseCaseProtocol
    @Published public var user: User?
    @Published public var isLoading: Bool = false
    @Published public var currentTheme: Theme = .system
    @Published public var isNotificationsEnabled: Bool = true
    @Published public var language: String = "한국어"
    @Published public var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        print("👤 ProfileViewModel 생성 - @Dependency 방식")
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
}
