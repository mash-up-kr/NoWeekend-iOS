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
    private let calendar = Calendar.current
    
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    public func getWeeklySchedules(for date: Date) async throws -> [DailySchedule] {
            let (startDate, endDate) = calculateWeekRange(for: date)
            return try await getSchedulesForDateRange(startDate: startDate, endDate: endDate)
        }
        
        public func getMonthlySchedules(for date: Date) async throws -> [DailySchedule] {
            let (startDate, endDate) = calculateMonthRange(for: date)
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
        
        private func calculateWeekRange(for date: Date) -> (Date, Date) {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
                return (date, date)
            }
            return (weekInterval.start, calendar.date(byAdding: .day, value: -1, to: weekInterval.end) ?? weekInterval.end)
        }
        
        private func calculateMonthRange(for date: Date) -> (Date, Date) {
            guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
                return (date, date)
            }
            return (monthInterval.start, calendar.date(byAdding: .day, value: -1, to: monthInterval.end) ?? monthInterval.end)
        }
}
