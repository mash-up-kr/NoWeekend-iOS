//
//  GoogleSignInResult.swift
//  Domain
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation

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
