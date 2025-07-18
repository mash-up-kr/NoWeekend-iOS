//
//  VacationRecommendDTO.swift
//  HomeData
//
//  Created by 김나희 on 7/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

// MARK: - 휴가 추천 요청 DTO
public struct VacationRecommendRequestDTO: Codable {
    public let days: Int
    public let travelStyle: String
    public let activityType: String
    public let restPreference: String
    public let leisurePreference: String
    
    public init(
        days: Int,
        travelStyle: String,
        activityType: String,
        restPreference: String,
        leisurePreference: String
    ) {
        self.days = days
        self.travelStyle = travelStyle
        self.activityType = activityType
        self.restPreference = restPreference
        self.leisurePreference = leisurePreference
    }
}

// MARK: - 휴가 추천 생성 응답 DTO
public struct VacationRecommendCreateResponseDTO: Codable {
    public let result: String
    public let data: String
    public let error: String?
    
    public init(result: String, data: String, error: String?) {
        self.result = result
        self.data = data
        self.error = error
    }
}

// MARK: - 휴가 추천 조회 응답 DTO
public struct VacationRecommendResponseDTO: Codable {
    public let result: String
    public let data: VacationRecommendDataDTO?
    public let error: String?
    
    public init(result: String, data: VacationRecommendDataDTO?, error: String?) {
        self.result = result
        self.data = data
        self.error = error
    }
}

public struct VacationRecommendDataDTO: Codable {
    public let title: String
    public let content: String
    public let iconStyle: String
    
    public init(title: String, content: String, iconStyle: String) {
        self.title = title
        self.content = content
        self.iconStyle = iconStyle
    }
}

// MARK: - DTO to Domain 변환
import HomeDomain

extension VacationRecommendRequestDTO {
    public func toDomain() -> VacationRecommendRequest {
        return VacationRecommendRequest(
            days: days,
            travelStyle: travelStyle,
            activityType: activityType,
            restPreference: restPreference,
            leisurePreference: leisurePreference
        )
    }
}

extension VacationRecommendRequest {
    public func toDTO() -> VacationRecommendRequestDTO {
        return VacationRecommendRequestDTO(
            days: days,
            travelStyle: travelStyle,
            activityType: activityType,
            restPreference: restPreference,
            leisurePreference: leisurePreference
        )
    }
}

extension VacationRecommendDataDTO {
    public func toDomain() -> VacationRecommend {
        return VacationRecommend(
            title: title,
            content: content,
            iconStyle: iconStyle
        )
    }
} 
