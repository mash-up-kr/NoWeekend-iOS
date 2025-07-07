//
//  GoogleAuthService.swift
//  Network
//
//  Created by 김시종 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import GoogleSignIn
import UIKit
import LoginDomain

public protocol GoogleAuthServiceInterface {
    @MainActor
    func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult
    
    @MainActor
    func signOut()
}

public final class GoogleAuthService: GoogleAuthServiceInterface {
    public init() {}
    
    @MainActor
    public func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult {
        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result else {
                    let error = NSError(
                        domain: "GoogleSignInError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No result received"]
                    )
                    continuation.resume(throwing: error)
                    return
                }
                
                let user = result.user
                let accessToken = user.accessToken.tokenString
                
                let signInResult = GoogleSignInResult(
                    accessToken: accessToken,
                    name: user.profile?.name,
                    email: user.profile?.email
                )
                
                continuation.resume(returning: signInResult)
            }
        }
    }

    @MainActor
    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
