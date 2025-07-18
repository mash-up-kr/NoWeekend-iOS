//
//  OnboardingStatusResponseDTO.swift
//  OnboardingData
//
//  Created by SiJongKim on 7/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct OnboardingStatusResponseDTO: Decodable {
    public let result: String
    public let data: StatusData
    public let error: ErrorInfo?
    
    public struct StatusData: Decodable {
        public let status: String
    }
}
