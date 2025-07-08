//
//  LoginModels.swift
//  Calendar
//
//  Created by SiJongKim on 6/12/25.
//

import Foundation
import LoginDomain

public enum LoginIntent {
    case signInWithGoogle
    case signInWithApple
    case signInSucceeded(user: LoginUser)
    case signInFailed(error: Error)
    case signOut
}

public struct LoginState {
    public var isSignedIn: Bool = false
    public var userEmail: String = ""
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    
    public init() {}
}

public enum LoginEffect {
    case showError(message: String)
    case navigateToHome
}
