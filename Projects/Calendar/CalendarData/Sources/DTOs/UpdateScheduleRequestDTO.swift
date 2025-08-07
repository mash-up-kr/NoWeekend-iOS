//
//  UpdateScheduleRequestDTO.swift
//  CalendarData
//
//  Created by 이지훈 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import Foundation

public struct UpdateScheduleRequestDTO: Encodable, Sendable {
    public let title: String
    public let startTime: String
    public let endTime: String
    public let category: String
    public let temperature: Int
    public let allDay: Bool
    public let alarmOption: String
    
    public init(
        title: String,
        startTime: String,
        endTime: String,
        category: String,
        temperature: Int,
        allDay: Bool,
        alarmOption: String
    ) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.category = category
        self.temperature = temperature
        self.allDay = allDay
        self.alarmOption = alarmOption
    }
}

public struct UpdateScheduleResponseDTO: Decodable, Sendable {
    public let id: String
    public let title: String
    public let startTime: String
    public let endTime: String
    public let category: String
    public let temperature: Int
    public let allDay: Bool
    public let alarmOption: String
    public let completed: Bool
    
    public func toDomain() -> Schedule {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        let backupFormatter = DateFormatter()
        backupFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        backupFormatter.timeZone = TimeZone.current
        
        let startDate = isoFormatter.date(from: startTime)
                     ?? backupFormatter.date(from: startTime)
                     ?? Date()
                     
        let endDate = isoFormatter.date(from: endTime)
                   ?? backupFormatter.date(from: endTime)
                   ?? Date()
        
        return Schedule(
            id: id,
            title: title,
            startTime: startDate,
            endTime: endDate,
            category: ScheduleCategory(rawValue: category) ?? .etc,
            temperature: temperature,
            allDay: allDay,
            alarmOption: AlarmOption(rawValue: alarmOption) ?? .none,
            completed: completed
        )
    }
}

public struct UpdateScheduleAPIResponseDTO: Decodable, Sendable {
    public let result: String
    public let data: UpdateScheduleResponseDTO?
    public let error: APIError?
}
