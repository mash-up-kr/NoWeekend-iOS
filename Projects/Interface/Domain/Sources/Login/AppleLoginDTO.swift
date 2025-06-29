//
//  AppleLoginDTO.swift
//  Domain
//
//  Created by 김시종 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct AppleLoginResponseDTO: Decodable {
    public let email: String?  // Apple은 email이 선택적
    public let exists: Bool
    public let accessToken: String
    public let appleUserId: String?  // Apple 고유 ID
    
    public init(email: String?, exists: Bool, accessToken: String, appleUserId: String?) {
        self.email = email
        self.exists = exists
        self.accessToken = accessToken
        self.appleUserId = appleUserId
    }
}

public struct ApiResponseAppleLoginDTO: Decodable {
    public let result: String
    public let data: AppleLoginResponseDTO
    public let error: ErrorMessageDTO?
    
    public init(result: String, data: AppleLoginResponseDTO, error: ErrorMessageDTO?) {
        self.result = result
        self.data = data
        self.error = error
    }
}

extension AppleLoginResponseDTO {
    public func toDomain() -> LoginUser {
        return LoginUser(
            email: self.email ?? "",  // Apple의 경우 이메일이 없을 수 있음
            isExistingUser: self.exists,
            accessToken: self.accessToken
        )
    }
}
