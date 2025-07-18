//
//  HomeEndpoint.swift
//  HomeData
//
//  Created by 김나희 on 2025/07/13.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

enum HomeEndpoint {
    /// 위치 등록 (POST)
    case registerLocation
    /// 날씨 기반 추천 (GET)
    case getWeatherRecommendations
    case getSandwichHoliday
    case getHolidays
    /// 휴가 추천 생성 (POST)
    case createVacationRecommend
    /// 휴가 추천 조회 (GET)
    case getVacationRecommend
    
    
    var path: String {
        switch self {
        case .registerLocation:
            return "/user/location"
            
        case .getWeatherRecommendations:
            return "/recommend/weather"
        case .getSandwichHoliday:
            return "/recommend/sandwich"
        case .getHolidays:
            return "/holiday/remaining"
        case .createVacationRecommend:
            return "/recommend/vacation"
        case .getVacationRecommend:
            return "/recommend/vacation"
        }
    }
} 
