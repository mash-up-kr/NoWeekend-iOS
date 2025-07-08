//
//  ScheduleResponseDTO.swift
//  CalendarData
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct ScheduleResponseDTO: Decodable {
    public let result: String
    public let data: [DailyScheduleDTO]
    public let error: APIError?
}

public struct APIError: Decodable {
    public let code: String
    public let message: String
    public let data: [String: String]?
}
