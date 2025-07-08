//
//  GoogleAuthService.swift
//  Network
//
//  Created by 김시종 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import GoogleSignIn
import LoginDomain
import UIKit

public final class GoogleAuthService: GoogleAuthServiceInterface {
    public init() {
        print("🔐 GoogleAuthService 초기화 완료")
    }
    
    @MainActor
    public func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult {
        print("🚀 Google 로그인 시작")
        print("📱 PresentingViewController: \(type(of: presentingViewController))")
        
        // Google Sign-In 설정 상태 확인
        guard let configuration = GIDSignIn.sharedInstance.configuration else {
            print("❌ Google Sign-In 설정이 없습니다.")
            throw NSError(domain: "GoogleSignIn", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Google Sign-In 설정이 누락되었습니다."])
        }
        
        print("✅ Google Sign-In 설정 확인:")
        print("   - Client ID: \(configuration.clientID)")
        print("   - Server Client ID: \(configuration.serverClientID ?? "없음")")
        
        return try await withCheckedThrowingContinuation { continuation in
            print("🔄 GIDSignIn.signIn 호출 시작")
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
                print("📞 Google Sign-In 콜백 받음")
                
                if let error = error {
                    print("❌ Google Sign-In 오류 발생:")
                    print("   - Error Domain: \(error._domain)")
                    print("   - Error Code: \(error._code)")
                    print("   - Error Description: \(error.localizedDescription)")
                    print("   - Error UserInfo: \(error)")
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result else {
                    print("❌ Google Sign-In 결과가 nil입니다.")
                    let error = NSError(
                        domain: "GoogleSignInError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No result received"]
                    )
                    continuation.resume(throwing: error)
                    return
                }
                
                print("✅ Google Sign-In 성공! 결과 분석:")
                
                let user = result.user
                print("👤 사용자 정보:")
                print("   - User ID: \(user.userID ?? "없음")")
                
                // 프로필 정보 확인
                if let profile = user.profile {
                    print("📋 프로필 정보:")
                    print("   - Name: \(profile.name)")
                    print("   - Email: \(profile.email)")
                    print("   - Given Name: \(profile.givenName ?? "없음")")
                    print("   - Family Name: \(profile.familyName ?? "없음")")
                    print("   - Has Image: \(profile.hasImage)")
                    if profile.hasImage {
                        print("   - Image URL: \(profile.imageURL(withDimension: 200)?.absoluteString ?? "없음")")
                    }
                } else {
                    print("⚠️ 프로필 정보가 없습니다.")
                }
                
                // 토큰 정보 확인
                print("🎫 토큰 정보:")
                let accessToken = user.accessToken.tokenString
                print("   - Access Token 길이: \(accessToken.count)자")
                print("   - Access Token 앞 10자: \(String(accessToken.prefix(10)))...")
                
                if let idToken = user.idToken {
                    print("   - ID Token 길이: \(idToken.tokenString.count)자")
                    print("   - ID Token 앞 10자: \(String(idToken.tokenString.prefix(10)))...")
                } else {
                    print("   - ID Token: 없음")
                }
                
                // 권한 범위 확인
                if let grantedScopes = user.grantedScopes {
                    print("🔑 부여된 권한:")
                    for scope in grantedScopes {
                        print("   - \(scope)")
                    }
                } else {
                    print("🔑 부여된 권한: 없음")
                }
                
                // GoogleSignInResult 생성
                let authorizationCode = accessToken
                let signInResult = GoogleSignInResult(
                    authorizationCode: authorizationCode,
                    name: user.profile?.name,
                    email: user.profile?.email
                )
                
                print("📦 GoogleSignInResult 생성:")
                print("   - Authorization Code 길이: \(signInResult.authorizationCode.count)자")
                print("   - Name: \(signInResult.name ?? "없음")")
                print("   - Email: \(signInResult.email ?? "없음")")
                
                print("✅ Google 로그인 완료 - UseCase로 전달")
                continuation.resume(returning: signInResult)
            }
        }
    }

    @MainActor
    public func signOut() {
        print("🚪 Google 로그아웃 시작")
        GIDSignIn.sharedInstance.signOut()
        print("✅ Google 로그아웃 완료")
    }
}
