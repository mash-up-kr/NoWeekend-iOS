//
//  GoogleSignInResult.swift
//  Domain
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation

public struct GoogleSignInResult {
    public let authorizationCode: String
    public let name: String?
    public let email: String?
    
    public init(authorizationCode: String, name: String?, email: String?) {
        self.authorizationCode = authorizationCode
        self.name = name
        self.email = email
    }
}
