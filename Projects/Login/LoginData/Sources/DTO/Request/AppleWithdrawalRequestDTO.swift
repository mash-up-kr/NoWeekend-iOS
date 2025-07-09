//
//  AppleWithdrawalRequestDTO.swift
//  LoginData
//
//  Created by SiJongKim on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation


public struct AppleWithdrawalRequestDTO: Codable {
    let identityToken: String
    
    public init(identityToken: String) {
        self.identityToken = identityToken
    }
}
