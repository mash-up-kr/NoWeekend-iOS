//
//  LoginRequestDTO.swift
//  Network
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation

public struct LoginRequestDTO: Encodable {
    public let accessToken: String
    public let name: String?
    
    public init(accessToken: String, name: String?) {
        self.accessToken = accessToken
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        
        if let name = name {
            try container.encode(name, forKey: .name)
        }
    }
}
