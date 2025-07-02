//
//  OnboardingDataDTO.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct OnboardingDataDTO: Decodable {
    public let userId: String?
    public let step: Int?
    
    public init(userId: String? = nil, step: Int? = nil) {
        self.userId = userId
        self.step = step
    }
}
