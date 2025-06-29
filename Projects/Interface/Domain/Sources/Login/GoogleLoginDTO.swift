//
//  GoogleLoginDTO.swift
//  Domain
//
//  Created by 김시종 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct GoogleLoginResponseDTO: Decodable {
    public let email: String
    public let exists: Bool
    public let accessToken: String
    
    public init(email: String, exists: Bool, accessToken: String) {
        self.email = email
        self.exists = exists
        self.accessToken = accessToken
    }
}

public struct ApiResponseGoogleLoginDTO: Decodable {
    public let result: String
    public let data: GoogleLoginResponseDTO
    public let error: ErrorMessageDTO?
    
    public init(result: String, data: GoogleLoginResponseDTO, error: ErrorMessageDTO?) {
        self.result = result
        self.data = data
        self.error = error
    }
}

extension GoogleLoginResponseDTO {
    public func toDomain() -> LoginUser {
        return LoginUser(
            email: self.email,
            isExistingUser: self.exists,
            accessToken: self.accessToken
        )
    }
}
