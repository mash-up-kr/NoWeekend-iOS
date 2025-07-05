//
//  Event.swift
//  HomeDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

// MARK: - Event Entity  
public struct Event: Codable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public let date: Date
    public let description: String?
    public let category: EventCategory
    public let isCompleted: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String, 
        title: String, 
        date: Date, 
        description: String? = nil,
        category: EventCategory = .other,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.category = category
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Event Category
public enum EventCategory: String, Codable, CaseIterable {
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
