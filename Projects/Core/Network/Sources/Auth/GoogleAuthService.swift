//
//  GoogleAuthService.swift
//  Network
//
//  Created by SiJongKim on 6/12/25.
//

import Foundation
import GoogleSignIn
import Alamofire
import UIKit
import ServiceInterface


public final class GoogleAuthService: GoogleAuthServiceInterface {
    public init() {}
    
    public func signIn() async throws -> (accessToken: String, name: String?, email: String?) {
        let rootViewController: UIViewController? = await MainActor.run {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let root = scene.windows.first?.rootViewController else {
                return nil
            }
            return root
        }
        
        guard let root = rootViewController else {
            throw NSError(
                domain: "GoogleAuthService",
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
        let accessToken = user.accessToken.tokenString

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
    
    // MARK: - Token Verification with Alamofire
    private func verifyGoogleToken(_ accessToken: String) async {
        await checkTokenInfo(accessToken)
        await getUserInfo(accessToken)
    }
    
    private func checkTokenInfo(_ accessToken: String) async {
        let url = "https://www.googleapis.com/oauth2/v1/tokeninfo"
        let parameters: [String: String] = ["access_token": accessToken]
        
        do {
            let response = try await AF.request(
                url,
                method: .get,
                parameters: parameters
            ).serializingData().value
            
            if let jsonString = String(data: response, encoding: .utf8) {
                print("[Token Info] Response: \(jsonString)")
            }
        } catch {
            print("[Token Info] Error: \(error)")
        }
    }
    
    private func getUserInfo(_ accessToken: String) async {
        let url = "https://www.googleapis.com/oauth2/v2/userinfo"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        do {
            let response = try await AF.request(
                url,
                method: .get,
                headers: headers
            ).serializingData().value
            
            if let jsonString = String(data: response, encoding: .utf8) {
                print("[User Info] Response: \(jsonString)")
            }
        } catch {
            print("[User Info] Error: \(error)")
        }
    }
}

