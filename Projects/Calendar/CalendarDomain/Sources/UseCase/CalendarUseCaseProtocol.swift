//
//  CalendarUseCaseProtocol.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol CalendarUseCaseProtocol {
    func getWeeklySchedules(for date: Date) async throws -> [DailySchedule]
    func getMonthlySchedules(for date: Date) async throws -> [DailySchedule]
    func getSchedulesForDateRange(startDate: Date, endDate: Date) async throws -> [DailySchedule]
}
