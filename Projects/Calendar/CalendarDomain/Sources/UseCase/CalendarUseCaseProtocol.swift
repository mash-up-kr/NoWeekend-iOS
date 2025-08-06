//
//  CalendarUseCaseProtocol.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol CalendarUseCaseProtocol: Sendable {
    func getWeeklySchedules(for date: Date) async throws -> [DailySchedule]
    func getMonthlySchedules(for date: Date) async throws -> [DailySchedule]
    func getSchedulesForDateRange(startDate: Date, endDate: Date) async throws -> [DailySchedule]
    func createSchedule(
        title: String,
        date: Date,
        startTime: Date,
        endTime: Date,
        category: ScheduleCategory,
        temperature: Int,
        allDay: Bool,
        alarmOption: AlarmOption
    ) async throws -> Schedule
    func updateSchedule(
        id: String,
        title: String,
        startTime: Date,
        endTime: Date,
        category: ScheduleCategory,
        temperature: Int,
        allDay: Bool,
        alarmOption: AlarmOption
    ) async throws -> Schedule
    func deleteSchedule(id: String) async throws
    func getRecommendedTags() async throws -> RecommendTagResponse
    func updateScheduleState(id: String, isComplete: Bool) async throws -> Schedule
}
