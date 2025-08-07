//
//  ScheduleCategory.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum ScheduleCategory: String, Codable, CaseIterable, Sendable {
    case company = "COMPANY"
    case personal = "PERSONAL"
    case etc = "ETC"
    case leave = "LEAVE"
    
    public var displayName: String {
        switch self {
        case .company: return "회사"
        case .personal: return "개인"
        case .etc: return "기타"
        case .leave: return "연차"
        }
    }
}
