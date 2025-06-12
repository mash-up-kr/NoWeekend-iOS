//
//  LoginStore.swift
//  Calendar
//
//  Created by SiJongKim on 6/12/25.
//

import Foundation
import Combine
import LoginInterface
import ServiceInterface
import NetworkInterface
import Common

@MainActor
public final class LoginStore: ObservableObject {
    @Published private(set) var state = LoginState()
    let effect = PassthroughSubject<LoginEffect, Never>()
    
    private let loginUseCase: LoginWithGoogleUseCaseInterface
    private let googleAuthService: GoogleAuthServiceInterface
    
    public init(
        loginUseCase: LoginWithGoogleUseCaseInterface,
        googleAuthService: GoogleAuthServiceInterface
    ) {
        self.loginUseCase = loginUseCase
        self.googleAuthService = googleAuthService
    }
    
    public func send(_ intent: LoginIntent) {
        switch intent {
        case .signInWithGoogle:
            handleGoogleSignIn()
        case .signInWithApple:
            break
        case .signInSucceeded(let user):
            state.isSignedIn = true
            state.userEmail = user.email
            state.isLoading = false
            effect.send(.navigateToHome)
        case .signInFailed(let error):
            state.errorMessage = error.localizedDescription
            state.isLoading = false
            effect.send(.showError(message: error.localizedDescription))
        case .signOut:
            googleAuthService.signOut()
            state = LoginState()
        }
    }
    
    private func handleGoogleSignIn() {
        state.errorMessage = ""
        state.isLoading = true
        
        Task {
            do {
                let signInResult = try await googleAuthService.signIn()
                
                do {
                    let user = try await loginUseCase.execute(
                        accessToken: signInResult.accessToken,
                        name: nil
                    )
                    send(.signInSucceeded(user: user))
                    
                } catch {
                    if let networkError = error as? NetworkError,
                       case .serverError(let message) = networkError,
                       message.contains("401") || message.contains("Unauthorized") {
                        
                        guard let profileName = signInResult.name,
                              !profileName.isEmpty else {
                            throw NSError(
                                domain: "",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "회원가입을 위한 이름을 가져올 수 없습니다."]
                            )
                        }
                        
                        let user = try await loginUseCase.execute(
                            accessToken: signInResult.accessToken,
                            name: profileName
                        )
                        send(.signInSucceeded(user: user))
                    } else {
                        send(.signInFailed(error: error))
                    }
                }
                
            } catch {
                print("❌ Google Sign-In failed: \(error)")
                send(.signInFailed(error: error))
            }
        }
    }
}
