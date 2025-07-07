//
//  GoogleLoginUseCase.swift
//  LoginDomain
//
//  Created by SiJongKim on 6/11/25.
//

import UIKit
import Foundation
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
        
        // Step 1: PresentingViewController 확인
        print("1️⃣ PresentingViewController 확인 중...")
        guard let presentingViewController = viewControllerProvider.getCurrentPresentingViewController() else {
            print("❌ PresentingViewController를 찾을 수 없습니다.")
            throw LoginError.noPresentingViewController
        }
        print("✅ PresentingViewController 찾음: \(type(of: presentingViewController))")
        
        do {
            // Step 2: 첫 번째 Google 인증 시도
            print("\n2️⃣ 첫 번째 Google 인증 시도 (이름 없이)")
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
            
            // Step 3: 첫 번째 서버 로그인 시도 (이름 없이)
            print("\n3️⃣ 서버 로그인 시도 (이름 없이)")
            print("📤 서버로 전송할 데이터:")
            print("   - Authorization Code 길이: \(signInResult.authorizationCode.count)자")
            print("   - Name: nil")
            
            let user = try await authRepository.loginWithGoogle(
                authorizationCode: signInResult.authorizationCode,
                name: nil
            )
            
            print("✅ 첫 번째 로그인 성공!")
            print("👤 로그인된 사용자 정보:")
            print("   - Email: \(user.email)")
            print("🎉 === Google 로그인 완료 ===\n")
            
            return user
            
        } catch {
            print("⚠️ 첫 번째 로그인 시도 실패:")
            print("   - Error Type: \(type(of: error))")
            print("   - Error: \(error)")
            
            if let loginError = error as? LoginError {
                print("🔍 LoginError 분석:")
                switch loginError {
                case .registrationRequired:
                    print("📝 회원가입이 필요한 상황 (exists: false)")
                    
                    // Step 4: 두 번째 Google 인증 시도 (회원가입용)
                    print("\n4️⃣ 회원가입을 위한 두 번째 Google 인증 시도")
                    let signInResult = try await googleAuthService.signIn(
                        presentingViewController: presentingViewController
                    )
                    
                    print("🔍 두 번째 Google 인증 결과 검증:")
                    print("   - Authorization Code 비어있음: \(signInResult.authorizationCode.isEmpty)")
                    print("   - Name: \(signInResult.name ?? "없음")")
                    print("   - Email: \(signInResult.email ?? "없음")")
                    
                    guard !signInResult.authorizationCode.isEmpty else {
                        print("❌ Google 재인증 코드가 비어있습니다.")
                        throw LoginError.authenticationFailed(
                            NSError(domain: "GoogleSignIn", code: -1,
                                   userInfo: [NSLocalizedDescriptionKey: "Google 재인증 코드를 받을 수 없습니다."])
                        )
                    }
                    
                    guard let profileName = signInResult.name, !profileName.isEmpty else {
                        print("❌ 프로필 이름을 가져올 수 없습니다.")
                        print("   - Name 값: \(signInResult.name ?? "nil")")
                        throw LoginError.nameNotAvailable
                    }
                    
                    print("✅ 프로필 이름 확인됨: \(profileName)")
                    
                    // Step 5: 회원가입 시도 (이름 포함)
                    print("\n5️⃣ 서버 회원가입 시도 (이름 포함)")
                    print("📤 서버로 전송할 데이터:")
                    print("   - Authorization Code 길이: \(signInResult.authorizationCode.count)자")
                    print("   - Name: \(profileName)")
                    
                    let user = try await authRepository.loginWithGoogle(
                        authorizationCode: signInResult.authorizationCode,
                        name: profileName
                    )
                    
                    print("✅ 회원가입 후 로그인 성공!")
                    print("👤 신규 사용자 정보:")
                    print("   - Email: \(user.email)")
                    print("🎉 === Google 회원가입 및 로그인 완료 ===\n")
                    
                    return user
                    
                case .authenticationFailed:
                    print("❌ 인증 실패")
                    throw loginError
                case .noPresentingViewController:
                    print("❌ PresentingViewController 없음")
                    throw loginError
                case .nameNotAvailable:
                    print("❌ 이름 정보 없음")
                    throw loginError
                case .appleSignInCancelled:
                    print("❌ Apple 로그인 취소")
                    throw loginError
                case .appleSignInFailed:
                    print("❌ Apple 로그인 실패")
                    throw loginError
                case .invalidAppleCredential:
                    print("❌ 잘못된 Apple 자격증명")
                    throw loginError
                }
            } else {
                print("❌ 예상하지 못한 오류:")
                print("   - Error: \(error)")
                print("💥 === Google 로그인 실패 ===\n")
                throw LoginError.authenticationFailed(error)
            }
        }
    }
}
