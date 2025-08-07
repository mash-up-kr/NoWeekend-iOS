//
//  UpdateScheduleStateResponseDTO.swift
//  CalendarData
//
//  Created by 이지훈 on 7/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct UpdateScheduleStateResponseDTO: Decodable, Sendable {
    public let result: String
    public let data: UpdateScheduleResponseDTO?
    public let error: APIError?
}
