//
//  CalendarEvent.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

// MARK: - Calendar Event Entity
public struct CalendarEvent: Codable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public let startDate: Date
    public let endDate: Date
    public let description: String?
    public let isAllDay: Bool
    public let category: CalendarEventCategory
    
    public init(
        id: String,
        title: String,
        startDate: Date,
        endDate: Date,
        description: String? = nil,
        isAllDay: Bool = false,
        category: CalendarEventCategory = .personal
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.isAllDay = isAllDay
        self.category = category
    }
}

// MARK: - Calendar Event Category
public enum CalendarEventCategory: String, Codable, CaseIterable {
    case work = "work"
    case personal = "personal"
    case health = "health"
    case education = "education"
    case social = "social"
    case travel = "travel"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .work: return "업무"
        case .personal: return "개인"
        case .health: return "건강"
        case .education: return "교육"
        case .social: return "사회"
        case .travel: return "여행"
        case .other: return "기타"
        }
    }
    
    public var color: String {
        switch self {
        case .work: return "blue"
        case .personal: return "green"
        case .health: return "red"
        case .education: return "purple"
        case .social: return "orange"
        case .travel: return "teal"
        case .other: return "gray"
        }
    }
}

