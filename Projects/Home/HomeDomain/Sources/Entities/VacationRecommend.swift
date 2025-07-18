//
//  VacationRecommend.swift
//  HomeDomain
//
//  Created by 김나희 on 7/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

// MARK: - 휴가 추천 요청 모델
public struct VacationRecommendRequest {
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

// MARK: - 휴가 추천 응답 모델
public struct VacationRecommend: Equatable {
    public let title: String
    public let content: String
    public let iconStyle: String
    public let startDate: String?
    public let endDate: String?
    
    public init(title: String, content: String, iconStyle: String, startDate: String? = nil, endDate: String? = nil) {
        self.title = title
        self.content = content
        self.iconStyle = iconStyle
        self.startDate = startDate
        self.endDate = endDate
    }
}

// MARK: - 휴가 추천 상태
public enum VacationRecommendStatus: Equatable {
    case none           // 휴가 추천 없음
    case requesting     // 휴가 추천 요청 중
    case ready          // 휴가 추천 완료
    case failed         // 휴가 추천 실패
}

public struct VacationRecommendState: Equatable {
    public let status: VacationRecommendStatus
    public let recommendation: VacationRecommend?
    public let error: String?
    
    public init(
        status: VacationRecommendStatus,
        recommendation: VacationRecommend? = nil,
        error: String? = nil
    ) {
        self.status = status
        self.recommendation = recommendation
        self.error = error
    }
} 
