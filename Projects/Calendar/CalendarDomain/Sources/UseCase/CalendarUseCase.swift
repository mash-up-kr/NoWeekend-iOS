//
//  CalendarUseCase.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Utils

public class CalendarUseCase: CalendarUseCaseProtocol {
    private let calendarRepository: CalendarRepositoryProtocol
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2  // 월요일 시작
        return cal
    }
    
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    public func getWeeklySchedules(for date: Date) async throws -> [DailySchedule] {
        let (startDate, endDate) = calculateWeekRange(for: date)
        return try await getSchedulesForDateRange(startDate: startDate, endDate: endDate)
    }
    
    public func getMonthlySchedules(for date: Date) async throws -> [DailySchedule] {
        let (startDate, endDate) = calculateMonthViewRange(for: date)
        return try await getSchedulesForDateRange(startDate: startDate, endDate: endDate)
    }
    
    public func getSchedulesForDateRange(startDate: Date, endDate: Date) async throws -> [DailySchedule] {
        let startDateString = startDate.toString(format: "yyyy-MM-dd")
        let endDateString = endDate.toString(format: "yyyy-MM-dd")
        
        return try await calendarRepository.getSchedules(
            startDate: startDateString,
            endDate: endDateString
        )
    }
    
    public func createSchedule(
        title: String,
        date: Date,
        startTime: Date,
        endTime: Date,
        category: ScheduleCategory,
        temperature: Int = 3,
        allDay: Bool = false,
        alarmOption: AlarmOption = .none
    ) async throws -> Schedule {
        let request = CreateScheduleRequest(
            title: title,
            date: date,
            startTime: startTime,
            endTime: endTime,
            category: category,
            temperature: temperature,
            allDay: allDay,
            alarmOption: alarmOption
        )
        
        return try await calendarRepository.createSchedule(request: request)
    }
    
    public func updateSchedule(
        id: String,
        title: String,
        startTime: Date,
        endTime: Date,
        category: ScheduleCategory,
        temperature: Int,
        allDay: Bool,
        alarmOption: AlarmOption
    ) async throws -> Schedule {
        let request = UpdateScheduleRequest(
            title: title,
            startTime: startTime,
            endTime: endTime,
            category: category,
            temperature: temperature,
            allDay: allDay,
            alarmOption: alarmOption
        )
        
        return try await calendarRepository.updateSchedule(id: id, request: request)
    }
    
    public func deleteSchedule(id: String) async throws {
        try await calendarRepository.deleteSchedule(id: id)
    }
    
    public func getRecommendedTags() async throws -> RecommendTagResponse {
        return try await calendarRepository.getRecommendedTags()
    }
    
    public func updateScheduleState(id: String, isComplete: Bool) async throws -> Schedule {
        return try await calendarRepository.updateScheduleState(id: id, isComplete: isComplete)
    }
}

// MARK: - Private Helper Methods
private extension CalendarUseCase {
    func calculateWeekRange(for date: Date) -> (Date, Date) {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return (date, date)
        }
        
        let startDate = weekInterval.start
        let endDate = calendar.date(byAdding: .day, value: -1, to: weekInterval.end) ?? weekInterval.end
        
        return (startDate, endDate)
    }
    
    func calculateMonthViewRange(for date: Date) -> (Date, Date) {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return (date, date)
        }
        
        let firstDayOfMonth = monthInterval.start
        let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: monthInterval.end) ?? monthInterval.end
        
        guard let firstWeekStart = calendar.dateInterval(of: .weekOfYear, for: firstDayOfMonth)?.start else {
            return (firstDayOfMonth, lastDayOfMonth)
        }
        
        guard let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: lastDayOfMonth),
              let lastWeekEnd = calendar.date(byAdding: .day, value: -1, to: lastWeekInterval.end) else {
            return (firstWeekStart, lastDayOfMonth)
        }
        
        return (firstWeekStart, lastWeekEnd)
    }
}
