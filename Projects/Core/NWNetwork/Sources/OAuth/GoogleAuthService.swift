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
            let strongVC = presentingViewController
            
            do {
                GIDSignIn.sharedInstance.signIn(withPresenting: strongVC) { result, error in

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
                
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    @MainActor
    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
