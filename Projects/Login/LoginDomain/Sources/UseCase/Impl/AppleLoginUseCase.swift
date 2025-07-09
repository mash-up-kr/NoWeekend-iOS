//
//  AppleLoginUseCase.swift
//  LoginDomain
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public final class AppleLoginUseCase: AppleLoginUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    private let appleAuthService: AppleAuthServiceInterface
    
    public nonisolated init(
        authRepository: AuthRepositoryInterface,
        appleAuthService: AppleAuthServiceInterface
    ) {
        self.authRepository = authRepository
        self.appleAuthService = appleAuthService
        print("🏗️ AppleLoginUseCase 초기화 완료")
    }
    
    @MainActor
    public func execute() async throws -> LoginUser {
        print("\n🍎 === Apple 로그인 UseCase 실행 시작 ===")
        
        // Step 1: Apple 인증 시도
        print("1️⃣ Apple 인증 시도")
        let signInResult = try await appleAuthService.signIn()
        
        print("🔍 Apple 인증 결과 분석:")
        print("   - User Identifier: \(signInResult.userIdentifier)")
        print("   - Email: \(signInResult.email ?? "없음")")
        print("   - Identity Token 있음: \(signInResult.identityToken != nil)")
        print("   - Authorization Code 있음: \(signInResult.authorizationCode != nil)")
        
        // Step 2: 이름 정보 처리
        print("\n2️⃣ 이름 정보 처리")
        let fullName = [
            signInResult.fullName?.givenName,
            signInResult.fullName?.familyName
        ].compactMap { $0 }.joined(separator: " ")
        
        let nameToSend = fullName.isEmpty ? nil : fullName
        
        print("   - 서버로 전송할 이름: \(nameToSend ?? "nil")")
        
        // Step 3: 인증 코드 준비
        print("\n3️⃣ 인증 코드 준비")
        print("   - Identity Token: \(signInResult.identityToken != nil ? "있음" : "없음")")
        print("   - Authorization Code: \(signInResult.authorizationCode != nil ? "있음" : "없음")")
        
        let authCode = signInResult.identityToken ?? ""
        
        guard !authCode.isEmpty else {
            throw LoginError.authenticationFailed(
                NSError(domain: "AppleSignIn", code: -1,
                       userInfo: [NSLocalizedDescriptionKey: "Apple 인증 토큰을 받을 수 없습니다."])
            )
        }
        
        do {
            let user = try await authRepository.loginWithApple(
                authorizationCode: authCode,
                name: nil
            )
            
            print("   - Email: \(user.email)")
            print("🎉 === Apple 로그인 완료 ===\n")
            
            return user
            
        } catch {
            print("⚠️ 첫 번째 로그인 시도 실패:")
            print("   - Error: \(error)")
            
            if let loginError = error as? LoginError {
                switch loginError {
                case .registrationRequired:
                    guard let name = nameToSend, !name.isEmpty else {
                        throw LoginError.nameNotAvailable
                    }
                    
                    print("✅ 회원가입용 이름 확인됨: '\(name)'")
                    
                    let user = try await authRepository.loginWithApple(
                        authorizationCode: authCode,
                        name: name
                    )
                    
                    print("✅ 회원가입 후 로그인 성공!")
                    print("👤 신규 사용자 정보:")
                    print("   - Email: \(user.email)")
                    print("🎉 === Apple 회원가입 및 로그인 완료 ===\n")
                    
                    return user
                    
                case .authenticationFailed:
                    throw loginError
                case .noPresentingViewController:
                    throw loginError
                case .nameNotAvailable:
                    throw loginError
                case .appleSignInCancelled:
                    throw loginError
                case .appleSignInFailed:
                    throw loginError
                case .invalidAppleCredential:
                    throw loginError
                case .withdrawalFailed(_):
                    throw loginError
                case .withdrawalCancelled:
                    throw loginError
                }
            } else {
                throw LoginError.authenticationFailed(error)
            }
        }
    }
}
