//
//  LoginEntity.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation

public struct UserEntity {
    public let email: String
    public let isExistingUser: Bool
    public let accessToken: String
    
    public init(email: String, isExistingUser: Bool, accessToken: String) {
        self.email = email
        self.isExistingUser = isExistingUser
        self.accessToken = accessToken
    }
}
