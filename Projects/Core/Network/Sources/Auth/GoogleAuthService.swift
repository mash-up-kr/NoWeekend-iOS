//
//  GoogleAuthService.swift
//  Network
//
//  Created by SiJongKim on 6/12/25.
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
