//
//  CreateScheduleDTO.swift
//  CalendarData
//
//  Created by 이지훈 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import Foundation

public struct CreateScheduleRequestDTO: Encodable, Sendable {
    public let title: String
    public let date: String
    public let startTime: String
    public let endTime: String
    public let category: String
    public let temperature: Int
    public let allDay: Bool
    public let alarmOption: String
}

// 응답 데이터 DTO - Decodable만 필요
public struct CreateScheduleDataDTO: Decodable, Sendable {
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
        
        // 백업 포맷터 (밀리초 없는 형태)
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

// 전체 응답 DTO - Decodable만 필요
public struct CreateScheduleResponseDTO: Decodable, Sendable {
    public let result: String
    public let data: CreateScheduleDataDTO?
    public let error: APIError?
}
