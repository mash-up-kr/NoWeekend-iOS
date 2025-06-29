//
//  LoginStore.swift
//  Calendar
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Combine
import LoginInterface
import Domain
import UseCase
import ServiceInterface
import UIKit
import NetworkInterface

@MainActor
public final class LoginStore: ObservableObject {
    @Published private(set) var state = LoginState()
    let effect = PassthroughSubject<LoginEffect, Never>()
    
    private let loginUseCase: LoginUseCaseInterface
    private let googleAuthService: GoogleAuthServiceInterface
    
    public init(
        loginUseCase: LoginUseCaseInterface,
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
            handleAppleSignIn()
        case .signInSucceeded(let user):
            handleSignInSuccess(user)
        case .signInFailed(let error):
            handleSignInFailure(error)
        case .signOut:
            handleSignOut()
        }
    }
    
    // MARK: - Private Methods
    private func handleGoogleSignIn() {
        state.errorMessage = ""
        state.isLoading = true
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            effect.send(.showError(message: "RootViewController를 찾을 수 없습니다."))
            state.isLoading = false
            return
        }
        
        Task {
            do {
                // ✅ GoogleAuthService에서 스레드 처리를 담당하므로 그대로 사용
                let googleResult = try await googleAuthService.signIn(presentingViewController: root)
                
                // 로그인 시도
                do {
                    let loginUser = try await loginUseCase.loginWithGoogle(
                        accessToken: googleResult.accessToken,
                        name: nil
                    )
                    send(.signInSucceeded(user: loginUser))
                    
                } catch let networkError as NetworkInterface.NetworkError {
                    // 401 Unauthorized → 신규 가입 분기
                    if case .serverError(let message) = networkError, message.contains("401") {
                        let profileName = googleResult.name ?? ""
                        guard !profileName.isEmpty else {
                            throw NSError(
                                domain: "",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "회원가입을 위한 이름을 가져올 수 없습니다."]
                            )
                        }
                        
                        let loginUser = try await loginUseCase.loginWithGoogle(
                            accessToken: googleResult.accessToken,
                            name: profileName
                        )
                        send(.signInSucceeded(user: loginUser))
                    } else {
                        send(.signInFailed(error: networkError))
                    }
                }
                
            } catch {
                print("❌ Google Sign-In failed: \(error)")
                send(.signInFailed(error: error))
            }
        }
    }
    
    private func handleAppleSignIn() {
        state.errorMessage = ""
        state.isLoading = true
        
        send(.signInFailed(error: NSError(domain: "", code: -1,
                                          userInfo: [NSLocalizedDescriptionKey: "Apple 로그인이 아직 구현되지 않았습니다."])))
    }
    
    private func handleSignInSuccess(_ user: LoginUser) {
        state.isSignedIn = true
        state.userEmail = user.email
        state.isLoading = false
        effect.send(.navigateToHome)
    }
    
    private func handleSignInFailure(_ error: Error) {
        state.errorMessage = error.localizedDescription
        state.isLoading = false
        effect.send(.showError(message: error.localizedDescription))
    }
    
    private func handleSignOut() {
        googleAuthService.signOut()
        loginUseCase.signOut()
        state = LoginState()
    }
}
