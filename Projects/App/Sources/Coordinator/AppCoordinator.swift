//
//  AppCoordinator.swift
//  App
//
//  Created by 김시종 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Combine
import Coordinator
import DIContainer
import SwiftUI
import LoginFeature
import NWNetwork
import OnboardingFeature

@MainActor
public final class AppCoordinator: ObservableObject, Coordinatorable {
    public typealias Screen = AppRouter.Screen
    public typealias SheetScreen = AppRouter.Sheet
    public typealias FullScreen = AppRouter.FullScreen
    
    public typealias PushView = AnyView
    public typealias SheetView = AnyView
    public typealias FullView = AnyView
    
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var sheet: SheetScreen?
    @Published public var fullScreenCover: FullScreen?

    @Published public var rootScreen: Screen = .login
    @Published public var isLoading: Bool = true
    @Published public var transitionDirection: TransitionDirection = .forward
    
    private var cancellables = Set<AnyCancellable>()
    private let tokenManager: TokenManagerInterface
    
    public init() {
        self.tokenManager = DIContainer.shared.resolve(TokenManagerInterface.self)
        
        setupLoginEffectBinding()
        
        checkInitialFlow()
    }

    public func view(_ screen: Screen) -> AnyView {
        switch screen {
        case .login:
            return AnyView(LoginView())
        case .onboarding:
            return AnyView(
                OnboardingView()
                    .onReceive(NotificationCenter.default.publisher(for: .init("OnboardingCompleted"))) { _ in
                        self.completeOnboarding()
                    }
            )
        case .main:
            return AnyView(TabBarView())
        }
    }
    
    public func presentView(_ sheet: SheetScreen) -> AnyView {
        switch sheet {
        case .none:
            return AnyView(EmptyView())
        }
    }
    
    public func fullCoverView(_ cover: FullScreen) -> AnyView {
        switch cover {
        case .none:
            return AnyView(EmptyView())
        }
    }
    
    private func setupLoginEffectBinding() {
        let loginStore: LoginStore = DIContainer.shared.resolve(LoginStore.self)
        
        loginStore.effect
            .receive(on: DispatchQueue.main)
            .sink { [weak self] effect in
                guard let self = self else { return }
                
                switch effect {
                case .navigateToHome:
                    self.handleLoginSuccess(shouldGoToMain: true)
                    
                case .navigateToOnboarding:
                    self.handleLoginSuccess(shouldGoToMain: false)
                    
                case .navigateToLogin:
                    self.handleLogout()
                    
                case .showError(let message):
                    self.isLoading = false
                    
                case .showWithdrawalSuccess:
                    self.isLoading = false
                    
                @unknown default:
                    print("⚠️ AppCoordinator - 알 수 없는 Effect: \(effect)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleLoginSuccess(shouldGoToMain: Bool) {
        let hasValidToken = tokenManager.hasValidAccessToken()
        
        guard hasValidToken else {
            safeNavigateToLogin()
            isLoading = false
            return
        }
        
        if shouldGoToMain {
            navigateToMainWithAnimation()
        } else {
            navigateToOnboardingWithAnimation()
        }
        
        isLoading = false
    }
    
    private func navigateToOnboardingWithAnimation() {
        if rootScreen == .login {
            safeAppendToPath(.onboarding)
        } else {
            rootScreen = .login
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.safeAppendToPath(.onboarding)
            }
        }
    }
    
    private func navigateToMainWithAnimation() {
        transitionDirection = .forward
        withAnimation(.easeInOut(duration: 0.3)) {
            self.rootScreen = .main
            self.safeResetPath()
        }
    }
    
    public func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboarding_completed")
        
        transitionDirection = .forward
        
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.5)) {
            self.rootScreen = .main
            self.safeResetPath()
        }
    }
    
    private func handleLogout() {
        safeResetAllNavigation()

        transitionDirection = .backward
    
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.rootScreen = .login
            }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.safeResetPath()
                self.isLoading = false
            }
        }
    }
    
    private func safeResetPath() {
        DispatchQueue.main.async {
            self.path = NavigationPath()
        }
    }

    private func safeAppendToPath(_ screen: Screen) {
        DispatchQueue.main.async {
            self.path.append(screen)
        }
    }
    
    private func safeResetAllNavigation() {
        sheet = nil
        fullScreenCover = nil
        
        DispatchQueue.main.async {
            self.safeResetPath()
        }
    }
    
    private func safeNavigateToLogin() {
        transitionDirection = .backward
        withAnimation(.easeInOut(duration: 0.3)) {
            rootScreen = .login
            safeResetPath()
        }
    }
    
    // MARK: - Public Navigation Methods
    
    public func navigateToLogin() {
        safeNavigateToLogin()
    }
    
    public func navigateToOnboarding() {
        if rootScreen == .login {
            safeAppendToPath(.onboarding)
        } else {
            transitionDirection = .forward
            withAnimation(.easeInOut(duration: 0.3)) {
                rootScreen = .login
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.safeAppendToPath(.onboarding)
            }
        }
    }
    
    public func navigateToMain() {
        transitionDirection = .forward
        withAnimation(.easeInOut(duration: 0.3)) {
            rootScreen = .main
            safeResetPath()
        }
    }
    
    private func checkInitialFlow() {
        isLoading = true
        
        let hasValidToken = tokenManager.hasValidAccessToken()
        
        if hasValidToken {
            let onboardingCompleted = UserDefaults.standard.bool(forKey: "onboarding_completed")
            
            if onboardingCompleted {
                rootScreen = .main
            } else {
                rootScreen = .login
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.rootScreen == .login {
                        self.safeAppendToPath(.onboarding)
                    }
                }
            }
        } else {
            rootScreen = .login
        }
        
        isLoading = false
    }
    
    public func refreshAuthenticationState() {
        checkInitialFlow()
    }
}

// MARK: - TransitionDirection

public enum TransitionDirection {
    case forward
    case backward
}
