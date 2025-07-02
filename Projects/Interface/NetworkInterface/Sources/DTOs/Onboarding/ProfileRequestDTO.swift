//
//  ProfileRequestDTO.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct ProfileRequestDTO {
    public let nickname: String
    public let birthDate: String
    
    public init(nickname: String, birthDate: String) {
        self.nickname = nickname
        self.birthDate = birthDate
    }
    
    public var toDictionary: [String: Any] {
        return [
            "nickname": nickname,
            "birthDate": birthDate
        ]
    }
}
