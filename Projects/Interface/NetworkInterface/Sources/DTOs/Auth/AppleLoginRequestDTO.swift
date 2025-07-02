//
//  AppleLoginRequestDTO.swift
//  Repository
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation


public struct AppleLoginRequestDTO: Encodable {
    public let identityToken: String
    public let authorizationCode: String?
    public let email: String?
    public let name: String?
    
    public init(identityToken: String, authorizationCode: String?, email: String?, name: String?) {
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
        self.email = email
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case identityToken
        case authorizationCode
        case email
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identityToken, forKey: .identityToken)
        
        if let authorizationCode = authorizationCode {
            try container.encode(authorizationCode, forKey: .authorizationCode)
        }
        if let email = email {
            try container.encode(email, forKey: .email)
        }
        if let name = name {
            try container.encode(name, forKey: .name)
        }
    }
}
