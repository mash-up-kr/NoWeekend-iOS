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
import ServiceInterface
import Domain

public final class GoogleAuthService: GoogleAuthServiceInterface {
    public init() {}
    
    public func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult {
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController,
            hint: nil,
            additionalScopes: ["profile", "email"]
        )
        
        let user = result.user
        let accessToken = user.accessToken.tokenString
        
        return GoogleSignInResult(
            accessToken: accessToken,
            name: user.profile?.name,
            email: user.profile?.email
        )
    }

    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
