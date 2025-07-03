//
//  User.swift
//  ProfileDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct User: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let email: String
    public let preferences: UserPreferences?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String, 
        name: String, 
        email: String,
        preferences: UserPreferences? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.preferences = preferences
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct UserPreferences: Codable, Equatable {
    public let theme: Theme
    public let isNotificationsEnabled: Bool
    public let language: String
    
    public init(
        theme: Theme = .system,
        isNotificationsEnabled: Bool = true,
        language: String = "ko"
    ) {
        self.theme = theme
        self.isNotificationsEnabled = isNotificationsEnabled
        self.language = language
    }
}

public enum Theme: String, Codable, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    public var displayName: String {
        switch self {
        case .system: return "시스템"
        case .light: return "라이트"
        case .dark: return "다크"
        }
    }
}
