//
//  OnboardingModel.swift
//  CalendarInterface
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation


public struct OnboardingProfile {
    public let nickname: String
    public let birthDate: String
    
    public init(nickname: String, birthDate: String) {
        self.nickname = nickname
        self.birthDate = birthDate
    }
}

public struct OnboardingLeave {
    public let days: Int
    public let hours: Int
    
    public init(days: Int, hours: Int) {
        self.days = days
        self.hours = hours
    }
}

public struct OnboardingTags {
    public let scheduleTags: [String]
    
    public init(scheduleTags: [String]) {
        self.scheduleTags = scheduleTags
    }
}
