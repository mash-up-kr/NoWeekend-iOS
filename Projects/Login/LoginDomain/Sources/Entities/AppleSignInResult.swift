//
//  AppleSignInResult.swift
//  Domain
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct AppleSignInResult {
    public let userIdentifier: String
    public let fullName: PersonNameComponents?
    public let email: String?
    public let identityToken: String?
    public let authorizationCode: String?
    
    public init(userIdentifier: String, fullName: PersonNameComponents?, email: String?, identityToken: String?, authorizationCode: String?) {
        self.userIdentifier = userIdentifier
        self.fullName = fullName
        self.email = email
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
    }
}
