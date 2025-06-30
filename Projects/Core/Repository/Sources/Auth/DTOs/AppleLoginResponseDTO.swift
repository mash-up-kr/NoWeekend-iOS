//
//  AppleLoginResponseDTO.swift
//  Repository
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain

public struct AppleLoginResponseDTO: Decodable {
    let email: String
    let exists: Bool
    let accessToken: String
}

public struct ApiResponseAppleLoginDTO: Decodable {
    let result: String
    let data: AppleLoginResponseDTO
    let error: ErrorMessageDTO?
}

extension AppleLoginResponseDTO {
    func toDomain() -> LoginUser {
        return LoginUser(
            email: self.email,
            accessToken: self.accessToken,
            isExistingUser: self.exists
        )
    }
}
