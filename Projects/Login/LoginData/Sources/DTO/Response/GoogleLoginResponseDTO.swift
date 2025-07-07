//
//  GoogleLoginResponseDTO.swift
//  Network
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import LoginDomain

public struct GoogleLoginResponseDTO: Decodable {
    public let email: String
    public let exists: Bool
    public let accessToken: String
}

public struct ApiResponseGoogleLoginDTO: Decodable {
    public let result: String
    public let data: GoogleLoginResponseDTO
    public let error: ErrorMessageDTO?
}

public struct ErrorMessageDTO: Decodable {
    public let code: String
    public let message: String
}

extension GoogleLoginResponseDTO {
    public func toDomain() -> LoginUser {
        LoginUser(
            email: self.email,
            accessToken: self.accessToken,
            isExistingUser: self.exists
        )
    }
}
