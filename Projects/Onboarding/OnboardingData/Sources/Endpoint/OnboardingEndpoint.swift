//
//  OnboardingEndpoint.swift
//  OnboardingData
//
//  Created by SiJongKim on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum OnboardingEndpoint {
    case profile
    case leave
    case tag
    case status

    public var path: String {
        switch self {
        case .profile:
            return "/user/onboarding/profile"
        case .leave:
            return "/user/onboarding/leave"
        case .tag:
            return "/user/onboarding/tag"
        case .status:
            return "/user/onboarding/status"
        }
    }
    
    public var method: String {
        switch self {
        case .profile, .leave, .tag:
            return "POST"
        case .status:
            return "GET"
        }
    }
}
