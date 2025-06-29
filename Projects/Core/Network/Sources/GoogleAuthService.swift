//
//  GoogleAuthService.swift
//  Network
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import GoogleSignIn
import UIKit
import ServiceInterface
import Domain

public final class GoogleAuthService: GoogleAuthServiceInterface {
    public init() {}

    @MainActor
    public func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult {
        // Ensure Google Sign-In is invoked on the main actor
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController,
            hint: nil,
            additionalScopes: ["profile", "email"]
        )

        let user = result.user
        let accessToken = user.accessToken.tokenString

        // Verify token in a background task
        Task.detached {
            await self.verifyGoogleToken(accessToken)
        }

        return GoogleSignInResult(
            accessToken: accessToken,
            name: user.profile?.name,
            email: user.profile?.email
        )
    }

    public func signOut() {
        // Must run on main thread
        DispatchQueue.main.async {
            GIDSignIn.sharedInstance.signOut()
        }
    }

    // MARK: - Private Methods

    private func verifyGoogleToken(_ accessToken: String) async {
        print("🔍 [Token Verification] 토큰 검증 시작")

        async let tokenInfo = checkTokenInfo(accessToken)
        async let userInfo = getUserInfo(accessToken)

        await tokenInfo
        await userInfo
    }

    private func checkTokenInfo(_ accessToken: String) async {
        let urlString = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=\(accessToken)"
        guard let url = URL(string: urlString) else {
            print("❌ [Token Verification] Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 [Token Info] Status Code: \(httpResponse.statusCode)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📊 [Token Info] Response: \(jsonString)")
            }
        } catch {
            print("❌ [Token Info] Error: \(error)")
        }
    }

    private func getUserInfo(_ accessToken: String) async {
        let urlString = "https://www.googleapis.com/oauth2/v2/userinfo"
        guard let url = URL(string: urlString) else {
            print("❌ [User Info] Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("👤 [User Info] Status Code: \(httpResponse.statusCode)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("👤 [User Info] Response: \(jsonString)")
            }
        } catch {
            print("❌ [User Info] Error: \(error)")
        }
    }
}
