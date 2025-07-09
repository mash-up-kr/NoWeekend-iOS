//
//  GoogleLoginUseCase.swift
//  LoginDomain
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import UIKit
import Utils

public final class GoogleLoginUseCase: GoogleLoginUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    private let googleAuthService: GoogleAuthServiceInterface
    private let viewControllerProvider: ViewControllerProviderInterface
    
    public nonisolated init(
        authRepository: AuthRepositoryInterface,
        googleAuthService: GoogleAuthServiceInterface,
        viewControllerProvider: ViewControllerProviderInterface
    ) {
        self.authRepository = authRepository
        self.googleAuthService = googleAuthService
        self.viewControllerProvider = viewControllerProvider
        print("🏗️ GoogleLoginUseCase 초기화 완료")
    }
    
    @MainActor
    public func execute() async throws -> LoginUser {
        print("\n🎯 === Google 로그인 UseCase 실행 시작 ===")
        
        guard let presentingViewController = viewControllerProvider.getCurrentPresentingViewController() else {
            print("❌ PresentingViewController를 찾을 수 없습니다.")
            throw LoginError.noPresentingViewController
        }
        print("✅ PresentingViewController 찾음: \(type(of: presentingViewController))")
        
        do {
            // Step 1: 첫 번째 Google 인증 시도
            print("\n1️⃣ 첫 번째 Google 인증 시도 (이름 없이)")
            let signInResult = try await googleAuthService.signIn(
                presentingViewController: presentingViewController
            )
            
            print("🔍 Google 인증 결과 검증:")
            print("   - Authorization Code 비어있음: \(signInResult.authorizationCode.isEmpty)")
            print("   - Name: \(signInResult.name ?? "없음")")
            print("   - Email: \(signInResult.email ?? "없음")")
            
            guard !signInResult.authorizationCode.isEmpty else {
                print("❌ Google 인증 코드가 비어있습니다.")
                throw LoginError.authenticationFailed(
                    NSError(domain: "GoogleSignIn", code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Google 인증 코드를 받을 수 없습니다."])
                )
            }
            
            // Step 2: 첫 번째 서버 API 호출 시도
            print("\n2️⃣ 첫 번째 서버 API 호출 시도")
            print("📤 서버로 전송할 데이터:")
            print("   - Authorization Code 길이: \(signInResult.authorizationCode.count)자")
            print("   - Authorization Code 앞 20자: \(String(signInResult.authorizationCode.prefix(20)))...")
            print("   - Name: nil (첫 번째 시도)")
            print("   - Email: \(signInResult.email ?? "없음")")
            
            print("🌐 AuthRepository.loginWithGoogle 호출 중...")
            
            let user = try await authRepository.loginWithGoogle(
                authorizationCode: signInResult.authorizationCode,
                name: nil
            )
            
            print("✅ 첫 번째 로그인 성공!")
            print("👤 로그인된 사용자 정보:")
            print("   - Email: \(user.email)")
            
            print("   - 기존 사용자 여부: \(user.isExistingUser)")
            print("🎉 === Google 로그인 완료 ===\n")
            
            return user
            
        } catch {
            print("\n⚠️ 첫 번째 로그인 시도 실패:")
            print("   - Error Type: \(type(of: error))")
            print("   - Error Description: \(error.localizedDescription)")
            
            if let loginError = error as? LoginError {
                print("🔍 LoginError 세부 분석:")
                switch loginError {
                case .registrationRequired(let underlyingError):
                    print("📝 회원가입이 필요한 상황 (exists: false)")
                    print("   - Underlying Error: \(underlyingError)")
                    
                    // Step 3: 두 번째 Google 인증 시도 (회원가입용)
                    print("\n3️⃣ 회원가입을 위한 두 번째 Google 인증 시도")
                    let secondSignInResult = try await googleAuthService.signIn(
                        presentingViewController: presentingViewController
                    )
                    
                    print("🔍 두 번째 Google 인증 결과 검증:")
                    print("   - Authorization Code 비어있음: \(secondSignInResult.authorizationCode.isEmpty)")
                    print("   - Name: \(secondSignInResult.name ?? "없음")")
                    print("   - Email: \(secondSignInResult.email ?? "없음")")
                    
                    guard !secondSignInResult.authorizationCode.isEmpty else {
                        print("❌ Google 재인증 코드가 비어있습니다.")
                        throw LoginError.authenticationFailed(
                            NSError(domain: "GoogleSignIn", code: -1,
                                   userInfo: [NSLocalizedDescriptionKey: "Google 재인증 코드를 받을 수 없습니다."])
                        )
                    }
                    
                    guard let profileName = secondSignInResult.name, !profileName.isEmpty else {
                        print("❌ 프로필 이름을 가져올 수 없습니다.")
                        print("   - Name 값: \(secondSignInResult.name ?? "nil")")
                        throw LoginError.nameNotAvailable
                    }
                    
                    
                    let newUser = try await authRepository.loginWithGoogle(
                        authorizationCode: secondSignInResult.authorizationCode,
                        name: profileName
                    )
                    
                    print("✅ 회원가입 후 로그인 성공!")
                    print("👤 신규 사용자 정보:")
                    print("   - Email: \(newUser.email)")
                    print("   - 기존 사용자 여부: \(newUser.isExistingUser)")
                    print("🎉 === Google 회원가입 및 로그인 완료 ===\n")
                    
                    return newUser
                    
                case .authenticationFailed(let underlyingError):
                    print("   - 인증 실패: \(underlyingError)")
                    throw loginError
                case .noPresentingViewController:
                    print("   - PresentingViewController 없음")
                    throw loginError
                case .nameNotAvailable:
                    print("   - 이름 정보 없음")
                    throw loginError
                case .appleSignInCancelled, .appleSignInFailed, .invalidAppleCredential:
                    print("   - Apple 관련 오류 (Google 로그인에서 발생)")
                    throw loginError
                case .withdrawalFailed, .withdrawalCancelled:
                    print("   - 탈퇴 관련 오류 (Google 로그인에서 발생)")
                    throw loginError
                }
            } else {
                throw LoginError.authenticationFailed(error)
            }
        }
    }
}
