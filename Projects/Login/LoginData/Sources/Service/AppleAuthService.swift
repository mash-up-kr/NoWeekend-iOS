//
//  AppleAuthService.swift
//  Repository
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import AuthenticationServices
import Foundation
import LoginDomain

@MainActor
public final class AppleAuthService: NSObject, ObservableObject, AppleAuthServiceInterface {
    private var currentContinuation: CheckedContinuation<AppleSignInResult, Error>?
    
    override public init() {
        super.init()
        print("🍎 AppleAuthService 초기화 완료")
    }
    
    public func signIn() async throws -> AppleSignInResult {
        print("🚀 Apple 로그인 시작")
        
        // Apple Sign-In 지원 여부 확인
        print("📱 Apple Sign-In 환경 체크:")
        print("   - iOS 버전: \(UIDevice.current.systemVersion)")
        
        return try await withCheckedThrowingContinuation { continuation in
            print("🔄 Apple Sign-In 요청 준비 중...")
            self.currentContinuation = continuation
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            print("📋 요청 설정:")
            print("   - 요청 범위: fullName, email")
            print("   - Provider: \(type(of: appleIDProvider))")
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            
            print("🎯 ASAuthorizationController 실행...")
            authorizationController.performRequests()
        }
    }
    
    public func getCredentialState(for userID: String) async throws -> String {
        print("🔍 Apple 자격증명 상태 확인 - UserID: \(userID)")
        
        return try await withCheckedThrowingContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) { credentialState, error in
                if let error = error {
                    print("❌ 자격증명 상태 확인 실패: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }
                
                let stateString: String
                switch credentialState {
                case .authorized:
                    stateString = "authorized"
                    print("✅ 자격증명 상태: 인증됨")
                case .revoked:
                    stateString = "revoked"
                    print("⚠️ 자격증명 상태: 철회됨")
                case .notFound:
                    stateString = "notFound"
                    print("❌ 자격증명 상태: 찾을 수 없음")
                @unknown default:
                    stateString = "unknown"
                    print("❓ 자격증명 상태: 알 수 없음")
                }
                
                continuation.resume(returning: stateString)
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleAuthService: ASAuthorizationControllerDelegate {
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        print("📞 Apple Sign-In 성공 콜백 받음")
        print("🔍 Authorization 정보:")
        print("   - Provider: \(authorization.provider)")
        print("   - Credential Type: \(type(of: authorization.credential))")
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ ASAuthorizationAppleIDCredential로 변환 실패")
            print("   - 실제 타입: \(type(of: authorization.credential))")
            currentContinuation?.resume(throwing: LoginError.invalidAppleCredential)
            currentContinuation = nil
            return
        }
        
        print("✅ Apple ID Credential 획득 성공")
        print("👤 사용자 정보:")
        print("   - User Identifier: \(appleIDCredential.user)")
        print("   - Email: \(appleIDCredential.email ?? "없음")")
        
        // 이름 정보 분석
        if let fullName = appleIDCredential.fullName {
            print("📋 이름 정보:")
            print("   - Given Name: \(fullName.givenName ?? "없음")")
            print("   - Family Name: \(fullName.familyName ?? "없음")")
            print("   - Middle Name: \(fullName.middleName ?? "없음")")
            print("   - Name Prefix: \(fullName.namePrefix ?? "없음")")
            print("   - Name Suffix: \(fullName.nameSuffix ?? "없음")")
        } else {
            print("⚠️ 이름 정보 없음 (기존 사용자일 가능성)")
        }
        
        // 토큰 정보 분석
        print("🎫 토큰 정보:")
        
        let identityToken = appleIDCredential.identityToken.flatMap {
            String(data: $0, encoding: .utf8)
        }
        
        if let identityToken = identityToken {
            print("   - Identity Token 길이: \(identityToken.count)자")
            print("   - Identity Token 앞 20자: \(String(identityToken.prefix(20)))...")
        } else {
            print("   - Identity Token: 없음")
        }
        
        let authorizationCode = appleIDCredential.authorizationCode.flatMap {
            String(data: $0, encoding: .utf8)
        }
        
        if let authorizationCode = authorizationCode {
            print("   - Authorization Code 길이: \(authorizationCode.count)자")
            print("   - Authorization Code 앞 20자: \(String(authorizationCode.prefix(20)))...")
        } else {
            print("   - Authorization Code: 없음")
        }
        
        // AppleSignInResult 생성
        let result = AppleSignInResult(
            userIdentifier: appleIDCredential.user,
            fullName: appleIDCredential.fullName,
            email: appleIDCredential.email,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
        
        print("📦 AppleSignInResult 생성:")
        print("   - User Identifier: \(result.userIdentifier)")
        print("   - Email: \(result.email ?? "없음")")
        print("   - Identity Token 있음: \(result.identityToken != nil)")
        print("   - Authorization Code 있음: \(result.authorizationCode != nil)")
        
        if let fullName = result.fullName {
            let combinedName = [fullName.givenName, fullName.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
            print("   - 결합된 이름: '\(combinedName)'")
        }
        
        print("✅ Apple 로그인 완료 - UseCase로 전달")
        currentContinuation?.resume(returning: result)
        currentContinuation = nil
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("❌ Apple Sign-In 오류 발생:")
        print("   - Error Type: \(type(of: error))")
        print("   - Error: \(error)")
        
        if let authError = error as? ASAuthorizationError {
            print("🔍 ASAuthorizationError 분석:")
            print("   - Error Code: \(authError.code.rawValue)")
            print("   - Error Description: \(authError.localizedDescription)")
            
            let loginError: LoginError
            switch authError.code {
            case .canceled:
                print("   - 원인: 사용자가 취소함")
                loginError = LoginError.appleSignInCancelled
            case .failed:
                print("   - 원인: 인증 실패")
                loginError = LoginError.appleSignInFailed
            case .invalidResponse:
                print("   - 원인: 잘못된 응답")
                loginError = LoginError.invalidAppleCredential
            case .notHandled:
                print("   - 원인: 처리되지 않음")
                loginError = LoginError.appleSignInFailed
            case .unknown:
                print("   - 원인: 알 수 없는 오류")
                loginError = LoginError.appleSignInFailed
            @unknown default:
                print("   - 원인: 새로운 오류 타입")
                loginError = LoginError.appleSignInFailed
            }
            
            currentContinuation?.resume(throwing: loginError)
        } else {
            print("❌ 예상하지 못한 오류:")
            print("   - \(error.localizedDescription)")
            currentContinuation?.resume(throwing: error)
        }
        
        currentContinuation = nil
    }
}
