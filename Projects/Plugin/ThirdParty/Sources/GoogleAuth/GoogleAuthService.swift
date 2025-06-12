//
//  GoogleAuthService.swift
//  Analytics
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import GoogleSignIn
import ServiceInterface
import Common
import UIKit

public final class DefaultGoogleAuthService: GoogleAuthServiceInterface {
    public init() {}
    
    public func signIn() async throws -> (accessToken: String, name: String?, email: String?) {
        guard let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = await scene.windows.first?.rootViewController else {
            throw NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "RootViewController를 찾을 수 없습니다."]
            )
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: root,
            hint: nil,
            additionalScopes: ["profile", "email"]
        )
        
        let user = result.user
        
        // 토큰 정보 출력
        let accessToken = user.accessToken.tokenString

        // 토큰 검증 (원래 코드와 동일)
        await verifyGoogleToken(accessToken)

        return (
            accessToken: accessToken,
            name: user.profile?.name,
            email: user.profile?.email
        )
    }
    
    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Token Verification
    private func verifyGoogleToken(_ accessToken: String) async {
        
        await checkTokenInfo(accessToken)
        await getUserInfo(accessToken)
    }
    
    private func checkTokenInfo(_ accessToken: String) async {
        let url = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=\(accessToken)"
        
        guard let tokenInfoURL = URL(string: url) else {
            print("[Token Verification] Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: tokenInfoURL)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("[Token Info] Status Code: \(httpResponse.statusCode)")
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[Token Info] Response: \(jsonString)")
            }
        } catch {
            print("[Token Info] Error: \(error)")
        }
    }
    
    private func getUserInfo(_ accessToken: String) async {
        let url = "https://www.googleapis.com/oauth2/v2/userinfo"
        
        guard let userInfoURL = URL(string: url) else {
            print("[User Info] Invalid URL")
            return
        }
        
        var request = URLRequest(url: userInfoURL)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("[User Info] Status Code: \(httpResponse.statusCode)")
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[User Info] Response: \(jsonString)")
            }
        } catch {
            print("[User Info] Error: \(error)")
        }
    }
}
