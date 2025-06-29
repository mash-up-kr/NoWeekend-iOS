//
//  LoginModel.swift
//  CalendarInterface
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain

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
    public var isLoading: Bool = false
    public var errorMessage: String = ""
    
    public init() {}
}

public enum LoginEffect {
    case showError(message: String)
    case navigateToHome
}
