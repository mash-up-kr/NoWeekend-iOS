//
//  ScheduleCategory.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum ScheduleCategory: String, Codable, CaseIterable {
    case company = "COMPANY"
    case personal = "PERSONAL"
    case health = "HEALTH"
    case education = "EDUCATION"
    case social = "SOCIAL"
    case travel = "TRAVEL"
    case other = "OTHER"
    
    public var displayName: String {
        switch self {
        case .company: return "회사"
        case .personal: return "개인"
        case .health: return "건강"
        case .education: return "교육"
        case .social: return "사회"
        case .travel: return "여행"
        case .other: return "기타"
        }
    }
}
