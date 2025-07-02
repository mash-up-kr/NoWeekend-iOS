//
//  OnboardingResponseDTO.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct OnboardingResponseDTO: Decodable {
    public let success: Bool
    public let message: String?
    public let data: OnboardingDataDTO?
    
    public init(success: Bool, message: String?, data: OnboardingDataDTO?) {
        self.success = success
        self.message = message
        self.data = data
    }
}
