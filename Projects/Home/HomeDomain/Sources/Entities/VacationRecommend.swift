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

// MARK: - 휴가 추천 에러 타입
public enum VacationRecommendError: Error, Equatable {
    case notReady // E404 - 아직 휴가가 생성되지 않았음
    case serverError(String) // 기타 서버 에러
    case networkError(String) // 네트워크 에러
    case unknown(String) // 알 수 없는 에러
    
    public var localizedDescription: String {
        switch self {
        case .notReady:
            return "아직 휴가가 생성되지 않았습니다."
        case .serverError(let message):
            return "서버 에러: \(message)"
        case .networkError(let message):
            return "네트워크 에러: \(message)"
        case .unknown(let message):
            return "알 수 없는 에러: \(message)"
        }
    }
}

// MARK: - 휴가 추천 상태
public enum VacationRecommendStatus: Equatable {
    case none           // 휴가 추천 없음
    case requesting     // 휴가 추천 요청 중
    case ready          // 휴가 추천 완료
    case failed         // 휴가 추천 실패
}

// MARK: - 휴가 추천 상태 모델
public struct VacationRecommendState: Equatable {
    public let status: VacationRecommendStatus
    public let recommendation: VacationRecommend?
    public let error: String?
    
    public init(status: VacationRecommendStatus, recommendation: VacationRecommend? = nil, error: String? = nil) {
        self.status = status
        self.recommendation = recommendation
        self.error = error
    }
} 
