//
//  AppleLoginResponseDTO.swift
//  Repository
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import LoginDomain

public struct AppleLoginResponseDTO: Decodable {
    public let email: String
    public let exists: Bool
    public let accessToken: String
}

public struct ApiResponseAppleLoginDTO: Decodable {
    public let result: String
    public let data: AppleLoginResponseDTO
    public let error: ErrorMessageDTO?
}

extension AppleLoginResponseDTO {
    public func toDomain() -> LoginUser {
        LoginUser(
            email: self.email,
            accessToken: self.accessToken,
            isExistingUser: self.exists
        )
    }
}
