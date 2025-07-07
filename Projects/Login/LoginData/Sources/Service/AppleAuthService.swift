//
//  AppleAuthService.swift
//  Repository
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import AuthenticationServices
import LoginDomain


@MainActor
public final class AppleAuthService: NSObject, ObservableObject, AppleAuthServiceInterface {
    private var currentContinuation: CheckedContinuation<AppleSignInResult, Error>?
    
    public override init() {}
    
    public func signIn() async throws -> AppleSignInResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.currentContinuation = continuation
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    public func getCredentialState(for userID: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) { credentialState, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                switch credentialState {
                case .authorized:
                    continuation.resume(returning: "authorized")
                case .revoked:
                    continuation.resume(returning: "revoked")
                case .notFound:
                    continuation.resume(returning: "notFound")
                @unknown default:
                    continuation.resume(returning: "unknown")
                }
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
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            currentContinuation?.resume(throwing: LoginError.invalidAppleCredential)
            currentContinuation = nil
            return
        }
        
        let identityToken = appleIDCredential.identityToken.flatMap {
            String(data: $0, encoding: .utf8)
        }
        let authorizationCode = appleIDCredential.authorizationCode.flatMap {
            String(data: $0, encoding: .utf8)
        }
        
        let result = AppleSignInResult(
            userIdentifier: appleIDCredential.user,
            fullName: appleIDCredential.fullName,
            email: appleIDCredential.email,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
        
        currentContinuation?.resume(returning: result)
        currentContinuation = nil
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                currentContinuation?.resume(throwing: LoginError.appleSignInCancelled)
            case .failed:
                currentContinuation?.resume(throwing: LoginError.appleSignInFailed)
            case .invalidResponse:
                currentContinuation?.resume(throwing: LoginError.invalidAppleCredential)
            case .notHandled:
                currentContinuation?.resume(throwing: LoginError.appleSignInFailed)
            case .unknown:
                currentContinuation?.resume(throwing: LoginError.appleSignInFailed)
            @unknown default:
                currentContinuation?.resume(throwing: LoginError.appleSignInFailed)
            }
        } else {
            currentContinuation?.resume(throwing: error)
        }
        currentContinuation = nil
    }
}
