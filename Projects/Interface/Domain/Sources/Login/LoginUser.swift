//
//  LoginEntity.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation

public struct LoginUser {
    public let email: String
    public let accessToken: String?
    public let isExistingUser: Bool?
    public let isOnboardingCompleted: Bool
    
    public init(email: String, accessToken: String?, isExistingUser: Bool?, isOnboardingCompleted: Bool = false) {
        self.email = email
        self.accessToken = accessToken
        self.isExistingUser = isExistingUser
        self.isOnboardingCompleted = isOnboardingCompleted
    }
}
