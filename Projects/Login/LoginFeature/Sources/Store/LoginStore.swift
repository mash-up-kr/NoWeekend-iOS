//
//  LoginStore.swift
//  Calendar
//
//  Created by SiJongKim on 6/12/25.
//

import Foundation
import Combine
import LoginDomain

public final class LoginStore: ObservableObject {
    @Published public private(set) var state = LoginState()
    public let effect = PassthroughSubject<LoginEffect, Never>()

    private let loginWithGoogleUseCase: GoogleLoginUseCaseInterface
    private let loginWithAppleUseCase: AppleLoginUseCaseInterface
    private let authUseCase: AuthUseCaseInterface

    public init(
        loginWithGoogleUseCase: GoogleLoginUseCaseInterface,
        loginWithAppleUseCase: AppleLoginUseCaseInterface,
        authUseCase: AuthUseCaseInterface
    ) {
        self.loginWithGoogleUseCase = loginWithGoogleUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.authUseCase = authUseCase
    }

    public func send(_ intent: LoginIntent) {
        switch intent {
        case .signInWithGoogle:
            Task { await handleGoogleSignIn() }
        case .signInWithApple:
            Task { await handleAppleSignIn() }
        case .signInSucceeded(let user):
            Task { await handleSignInSuccess(user) }
        case .signInFailed(let error):
            Task { await handleSignInFailure(error) }
        case .signOut:
            Task { await handleSignOut() }
        }
    }

    @MainActor
    private func handleGoogleSignIn() async {
        state.errorMessage = ""
        state.isLoading = true

        do {
            let user = try await loginWithGoogleUseCase.execute()
            send(.signInSucceeded(user: user))
        } catch {
            send(.signInFailed(error: error))
        }
    }

    @MainActor
    private func handleAppleSignIn() async {
        state.errorMessage = ""
        state.isLoading = true

        do {
            let user = try await loginWithAppleUseCase.execute()
            send(.signInSucceeded(user: user))
        } catch {
            send(.signInFailed(error: error))
        }
    }

    @MainActor
    private func handleSignInSuccess(_ user: LoginUser) {
        state.isSignedIn = true
        state.userEmail = user.email
        state.isLoading = false
        effect.send(.navigateToHome)
    }

    @MainActor
    private func handleSignInFailure(_ error: Error) {
        state.errorMessage = error.localizedDescription
        state.isLoading = false
        effect.send(.showError(message: error.localizedDescription))
    }

    @MainActor
    private func handleSignOut() {
        authUseCase.signOutGoogle()
        state = LoginState()
    }
}
