//
//  GoogleLoginResponseDTO.swift
//  Network
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import Domain

public struct GoogleLoginResponseDTO: Decodable {
    let email: String
    let exists: Bool
    let accessToken: String
}

public struct ApiResponseGoogleLoginDTO: Decodable {
    let result: String
    let data: GoogleLoginResponseDTO
    let error: ErrorMessageDTO?
}

public struct ErrorMessageDTO: Decodable {
    let code: String
    let message: String
}

extension GoogleLoginResponseDTO {
    func toDomain() -> LoginUser {
        return LoginUser(
            email: self.email,
<<<<<<< HEAD
=======
            name: nil,
>>>>>>> 2948d342ca4a17699338a4d2de2f4bfe1a2b77a1
            accessToken: self.accessToken,
            isExistingUser: self.exists
        )
    }
}
