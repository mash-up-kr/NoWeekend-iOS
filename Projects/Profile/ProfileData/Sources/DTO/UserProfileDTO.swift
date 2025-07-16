//
//  UserProfileDTO.swift
//  ProfileData
//
//  Created by SiJongKim on 7/11/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import ProfileDomain

struct ApiResponse<T: Decodable>: Decodable {
    let result: String
    let data: DataOrString<T>?
    let error: String?
}

enum DataOrString<T: Decodable>: Decodable {
    case data(T)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(T.self) {
            self = .data(data)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(
                DataOrString.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "data is not T or String")
            )
        }
    }
}

public struct UserProfileDTO: Codable {
    public let id: String
    public let email: String
    public let name: String
    public let gender: String
    public let providerId: String
    public let providerType: String
    public let revocableToken: String?
    public let role: String
    public let birthDate: String?
    public let remainingAnnualLeave: Double
    public let createdAt: String
    public let updatedAt: String
    public let location: UserLocationDTO?
    public let averageTemperature: Double
    
    public init(
        id: String,
        email: String,
        name: String,
        gender: String,
        providerId: String,
        providerType: String,
        revocableToken: String?,
        role: String,
        birthDate: String?,
        remainingAnnualLeave: Double,
        createdAt: String,
        updatedAt: String,
        location: UserLocationDTO?,
        averageTemperature: Double
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.gender = gender
        self.providerId = providerId
        self.providerType = providerType
        self.revocableToken = revocableToken
        self.role = role
        self.birthDate = birthDate
        self.remainingAnnualLeave = remainingAnnualLeave
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.location = location
        self.averageTemperature = averageTemperature
    }
}

public struct UserProfileUpdateRequestDTO: Codable {
    public let nickname: String
    public let birthDate: String
    
    public init(nickname: String, birthDate: String) {
        self.nickname = nickname
        self.birthDate = birthDate
    }
}
