//
//  OnboardingEndpoints.swift
//  Domain
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum OnboardingEndpoint {
    case profile
    case leave
    case tag
    
    public var path: String {
        switch self {
        case .profile:
            return "/api/v1/user/onboarding/profile"
        case .leave:
            return "/api/v1/user/onboarding/leave"
        case .tag:
            return "/api/v1/user/onboarding/tag"
        }
    }
    
    public var method: String {
        switch self {
        case .profile, .leave, .tag:
            return "POST"
        }
    }
}
