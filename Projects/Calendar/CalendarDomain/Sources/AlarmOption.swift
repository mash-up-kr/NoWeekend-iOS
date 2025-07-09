//
//  AlarmOption.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum AlarmOption: String, CaseIterable {
    case none = "NONE"
    case fiveMinutesBefore = "FIVE_MINUTES_BEFORE"
    case fifteenMinutesBefore = "FIFTEEN_MINUTES_BEFORE"
    case thirtyMinutesBefore = "THIRTY_MINUTES_BEFORE"
    case oneHourBefore = "ONE_HOUR_BEFORE"
    case oneDayBefore = "ONE_DAY_BEFORE"
    
    public var displayName: String {
        switch self {
        case .none: return "알림 없음"
        case .fiveMinutesBefore: return "5분 전"
        case .fifteenMinutesBefore: return "15분 전"
        case .thirtyMinutesBefore: return "30분 전"
        case .oneHourBefore: return "1시간 전"
        case .oneDayBefore: return "1일 전"
        }
    }
}
