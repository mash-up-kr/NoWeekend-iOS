//
//  MockCalendarRepository.swift
//  CalendarExampleApp
//
//  Created by 이지훈 on 7/22/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import Foundation

public class MockCalendarRepository: CalendarRepositoryProtocol {
    public func updateScheduleState(id: String, isComplete: Bool) async throws -> CalendarDomain.Schedule {
        print("✅ Mock: Updating schedule state for \(id) to \(isComplete ? "completed" : "not completed")")
        
        // Mock response
        return Schedule(
            id: id,
            title: "Mock Schedule",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            category: .company,
            temperature: 3,
            allDay: false,
            alarmOption: .none,
            completed: isComplete
        )
    }
    
    public init() {}
    
    public func getSchedules(startDate: String, endDate: String) async throws -> [DailySchedule] {
        // 지연시간 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
        
        let mockSchedule = Schedule(
            id: "mock-1",
            title: "Mock 회의",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            category: .company,
            temperature: 3,
            allDay: false,
            alarmOption: .none,
            completed: false
        )
        
        return [DailySchedule(
            date: startDate,
            dailyTemperature: 3,
            schedules: [mockSchedule]
        )]
    }
    
    public func createSchedule(request: CreateScheduleRequest) async throws -> Schedule {
        print("✅ Mock: Creating schedule '\(request.title)'")
        
        return Schedule(
            id: UUID().uuidString,
            title: request.title,
            startTime: request.startTime,
            endTime: request.endTime,
            category: request.category,
            temperature: request.temperature,
            allDay: request.allDay,
            alarmOption: request.alarmOption,
            completed: false
        )
    }
    
    public func updateSchedule(id: String, request: UpdateScheduleRequest) async throws -> Schedule {
        print("✅ Mock: Updating schedule '\(request.title)'")
        
        return Schedule(
            id: id,
            title: request.title,
            startTime: request.startTime,
            endTime: request.endTime,
            category: request.category,
            temperature: request.temperature,
            allDay: request.allDay,
            alarmOption: request.alarmOption,
            completed: false
        )
    }
    
    public func deleteSchedule(id: String) async throws {
        print("✅ Mock: Deleted schedule \(id)")
    }
    
    public func getRecommendedTags() async throws -> RecommendTagResponse {
        return RecommendTagResponse(
            result: "SUCCESS",
            data: RecommendTagData(
                firstRecommendTag: RecommendTag(content: "운동하기"),
                secondRecommendTag: RecommendTag(content: "회의하기"),
                thirdRecommendTag: RecommendTag(content: "휴식하기")
            ),
            error: nil
        )
    }
}
