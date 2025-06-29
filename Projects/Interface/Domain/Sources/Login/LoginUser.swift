//
//  LoginUser.swift
//  CalendarInterface
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct LoginUser {
    public let email: String
    public let isExistingUser: Bool
    public let accessToken: String
    
    public init(email: String, isExistingUser: Bool, accessToken: String) {
        self.email = email
        self.isExistingUser = isExistingUser
        self.accessToken = accessToken
    }
}
