//
//  DailyScheduleDTO.swift
//  CalendarData
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import CalendarDomain

public struct DailyScheduleDTO: Decodable {
    public let date: String
    public let schedules: [ScheduleDTO]
}

extension DailyScheduleDTO {
    public func toDomain() -> DailySchedule {
        return DailySchedule(
            date: date,
            schedules: schedules.map { $0.toDomain() }
        )
    }
}
