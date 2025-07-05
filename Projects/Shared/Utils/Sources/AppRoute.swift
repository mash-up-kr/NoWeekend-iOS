//
//  AppRoute.swift
//  Shared
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum AppRoute {
    case home
    case calendar
    case profile
    case onboarding
    
    public var path: String {
        switch self {
        case .home:
            return "/home"
        case .calendar:
            return "/calendar"
        case .profile:
            return "/profile"
        case .onboarding:
            return "/onboarding"
        }
    }
}
