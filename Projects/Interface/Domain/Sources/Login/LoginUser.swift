//
//  LoginEntity.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation

public struct LoginUser {
    public let email: String
    public let name: String?
    public let accessToken: String?
    public let isExistingUser: Bool?
    
    public init(email: String, name: String?, accessToken: String?, isExistingUser: Bool?) {
        self.email = email
        self.name = name
        self.accessToken = accessToken
        self.isExistingUser = isExistingUser
    }
}
