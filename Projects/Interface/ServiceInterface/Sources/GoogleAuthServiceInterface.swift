//
//  GoogleAuthServiceInterface.swift
//  CalendarInterface
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import UIKit
import Domain

public struct GoogleSignInResult {
    public let accessToken: String
    public let name: String?
    public let email: String?
    
    public init(accessToken: String, name: String?, email: String?) {
        self.accessToken = accessToken
        self.name = name
        self.email = email
    }
}

public protocol GoogleAuthServiceInterface {
    func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult
    func signOut()
}


