//
//  ScheduleDTO.swift
//  CalendarData
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import CalendarDomain

public struct ScheduleDTO: Decodable {
    public let id: String
    public let title: String
    public let startTime: String
    public let endTime: String
    public let category: String
    public let temperature: Int
    public let allDay: Bool
    public let alarmOption: String
    public let completed: Bool
}

extension ScheduleDTO {
    public func toDomain() -> Schedule {
        let dateFormatter = ISO8601DateFormatter()
        
        return Schedule(
            id: id,
            title: title,
            startTime: dateFormatter.date(from: startTime) ?? Date(),
            endTime: dateFormatter.date(from: endTime) ?? Date(),
            category: ScheduleCategory(rawValue: category) ?? .other,
            temperature: temperature,
            allDay: allDay,
            alarmOption: AlarmOption(rawValue: alarmOption) ?? .none,
            completed: completed
        )
    }
}
