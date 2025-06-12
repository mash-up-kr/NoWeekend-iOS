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
<<<<<<< HEAD
    public let isOnboardingCompleted: Bool
    
    public init(email: String, accessToken: String?, isExistingUser: Bool?, isOnboardingCompleted: Bool = false) {
        self.email = email
        self.accessToken = accessToken
        self.isExistingUser = isExistingUser
        self.isOnboardingCompleted = isOnboardingCompleted
=======
    
    public init(email: String, accessToken: String?, isExistingUser: Bool?) {
        self.email = email
        self.accessToken = accessToken
        self.isExistingUser = isExistingUser
>>>>>>> 2948d342ca4a17699338a4d2de2f4bfe1a2b77a1
    }
}
