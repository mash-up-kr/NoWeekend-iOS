//
//  MockCalendarRepository.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/24/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
@testable import CalendarDomain
@testable import CalendarFeature

// MARK: - Mock Repository
/**
 CalendarRepositoryProtocol의 테스트용 Mock 객체입니다.
 실제 네트워크나 데이터베이스 대신, 미리 정해진 데이터를 반환하여 유즈케이스나 뷰모델을 독립적으로 테스트할 수 있도록 합니다.
 */
class MockCalendarRepository: CalendarRepositoryProtocol {
    
    // MARK: - Mock Data Storage
    /// `getSchedules` 호출 시 반환될 모의 일일 스케줄 데이터 배열입니다.
    var mockSchedules: [DailySchedule] = []
    /// `createSchedule` 성공 시 반환될 모의 스케줄 객체입니다.
    var mockCreatedSchedule: Schedule?
    /// `updateSchedule` 또는 `updateScheduleState` 성공 시 반환될 모의 스케줄 객체입니다.
    var mockUpdatedSchedule: Schedule?
    /// `getRecommendedTags` 성공 시 반환될 모의 추천 태그 응답입니다.
    var mockRecommendTags: RecommendTagResponse?
    
    // MARK: - Call Tracking
    /// 각 프로토콜 메소드가 호출된 횟수를 기록하여 테스트에서 검증용으로 사용합니다.
    var getSchedulesCallCount = 0
    var createScheduleCallCount = 0
    var updateScheduleCallCount = 0
    var deleteScheduleCallCount = 0
    var updateScheduleStateCallCount = 0
    
    /// 마지막으로 호출된 메소드의 파라미터를 저장하여, 올바른 인자와 함께 호출되었는지 검증하는 데 사용합니다.
    var lastGetSchedulesParams: (startDate: String, endDate: String)?
    var lastCreatedScheduleRequest: CreateScheduleRequest?
    var lastUpdatedScheduleParams: (id: String, request: UpdateScheduleRequest)?
    var lastDeletedScheduleId: String?
    var lastUpdatedStateParams: (id: String, isComplete: Bool)?
    
    // MARK: - Error Simulation
    /// `true`로 설정하면 모든 메소드가 에러를 발생시킵니다. 에러 핸들링 로직 테스트에 사용됩니다.
    var shouldThrowError = false
    /// `shouldThrowError`가 true일 때 발생시킬 특정 에러 객체입니다.
    var errorToThrow: Error = NSError(domain: "MockError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Protocol Implementation
    /// 기간별 스케줄 조회 동작을 시뮬레이션합니다.
    func getSchedules(startDate: String, endDate: String) async throws -> [DailySchedule] {
        getSchedulesCallCount += 1
        lastGetSchedulesParams = (startDate, endDate)
        
        if shouldThrowError { throw errorToThrow }
        return mockSchedules
    }
    
    /// 스케줄 생성 동작을 시뮬레이션합니다.
    func createSchedule(request: CreateScheduleRequest) async throws -> Schedule {
        createScheduleCallCount += 1
        lastCreatedScheduleRequest = request
        
        if shouldThrowError { throw errorToThrow }
        
        // 미리 설정된 mock 객체가 없으면, 요청을 기반으로 새로운 mock 객체를 생성하여 반환합니다.
        return mockCreatedSchedule ?? createMockSchedule(from: request)
    }
    
    /// 스케줄 수정 동작을 시뮬레이션합니다.
    func updateSchedule(id: String, request: UpdateScheduleRequest) async throws -> Schedule {
        updateScheduleCallCount += 1
        lastUpdatedScheduleParams = (id, request)
        
        if shouldThrowError { throw errorToThrow }
        return mockUpdatedSchedule ?? createMockUpdatedSchedule(id: id, from: request)
    }
    
    /// 스케줄 삭제 동작을 시뮬레이션합니다.
    func deleteSchedule(id: String) async throws {
        deleteScheduleCallCount += 1
        lastDeletedScheduleId = id
        
        if shouldThrowError { throw errorToThrow }
    }
    
    /// 추천 태그 조회 동작을 시뮬레이션합니다.
    func getRecommendedTags() async throws -> RecommendTagResponse {
        if shouldThrowError { throw errorToThrow }
        return mockRecommendTags ?? createMockRecommendTags()
    }
    
    /// 스케줄 완료 상태 변경 동작을 시뮬레이션합니다.
    func updateScheduleState(id: String, isComplete: Bool) async throws -> Schedule {
        updateScheduleStateCallCount += 1
        lastUpdatedStateParams = (id, isComplete)
        
        if shouldThrowError { throw errorToThrow }
        return mockUpdatedSchedule ?? createMockScheduleWithCompletion(id: id, isComplete: isComplete)
    }
    
    // MARK: - Helper Methods
    /// 생성 요청 객체로부터 모의 스케줄을 생성합니다.
    private func createMockSchedule(from request: CreateScheduleRequest) -> Schedule {
        Schedule(id: "mock-\(UUID().uuidString)", title: request.title, startTime: request.startTime, endTime: request.endTime, category: request.category, temperature: request.temperature, allDay: request.allDay, alarmOption: request.alarmOption, completed: false)
    }
    
    /// 수정 요청 객체로부터 모의 스케줄을 생성합니다.
    private func createMockUpdatedSchedule(id: String, from request: UpdateScheduleRequest) -> Schedule {
        Schedule(id: id, title: request.title, startTime: request.startTime, endTime: request.endTime, category: request.category, temperature: request.temperature, allDay: request.allDay, alarmOption: request.alarmOption, completed: false)
    }
    
    /// 특정 완료 상태를 가진 모의 스케줄을 생성합니다.
    private func createMockScheduleWithCompletion(id: String, isComplete: Bool) -> Schedule {
        Schedule(id: id, title: "Mock Schedule", startTime: Date(), endTime: Date().addingTimeInterval(3600), category: .company, temperature: 50, allDay: false, alarmOption: .none, completed: isComplete)
    }
    
    /// 기본 모의 추천 태그 응답을 생성합니다.
    private func createMockRecommendTags() -> RecommendTagResponse {
        RecommendTagResponse(result: "SUCCESS", data: RecommendTagData(firstRecommendTag: RecommendTag(content: "운동하기"), secondRecommendTag: RecommendTag(content: "회의하기"), thirdRecommendTag: RecommendTag(content: "휴식하기")), error: nil)
    }
    
    // MARK: - Test Helper Methods
    /// 각 테스트 케이스가 끝난 후 Mock 객체의 모든 상태를 초기화하여 테스트 간 독립성을 보장합니다.
    func reset() {
        mockSchedules = []
        mockCreatedSchedule = nil
        mockUpdatedSchedule = nil
        mockRecommendTags = nil
        
        getSchedulesCallCount = 0
        createScheduleCallCount = 0
        updateScheduleCallCount = 0
        deleteScheduleCallCount = 0
        updateScheduleStateCallCount = 0
        
        lastGetSchedulesParams = nil
        lastCreatedScheduleRequest = nil
        lastUpdatedScheduleParams = nil
        lastDeletedScheduleId = nil
        lastUpdatedStateParams = nil
        
        shouldThrowError = false
    }
}

// MARK: - Mock UseCase
/**
 CalendarUseCaseProtocol의 테스트용 Mock 객체입니다.
 뷰모델 테스트에서 유즈케이스의 응답(성공 또는 실패)을 미리 정의하여, 뷰모델이 각 상황에 맞게 올바르게 상태를 변경하는지 검증하는 데 사용됩니다.
 */
class MockCalendarUseCase: CalendarUseCaseProtocol {
    
    // MARK: - Mock Results
    /// 각 유즈케이스 메소드가 반환할 `Result` 타입의 결과 값입니다. `.success` 또는 `.failure`를 설정하여 테스트 시나리오를 제어할 수 있습니다.
    var getWeeklySchedulesResult: Result<[DailySchedule], Error> = .success([])
    var getMonthlySchedulesResult: Result<[DailySchedule], Error> = .success([])
    var getSchedulesForDateRangeResult: Result<[DailySchedule], Error> = .success([])
    var createScheduleResult: Result<Schedule, Error> = .success(MockHelpers.createMockSchedule())
    var updateScheduleResult: Result<Schedule, Error> = .success(MockHelpers.createMockSchedule())
    var deleteScheduleResult: Result<Void, Error> = .success(())
    var getRecommendedTagsResult: Result<RecommendTagResponse, Error> = .success(MockHelpers.createMockRecommendTags())
    var updateScheduleStateResult: Result<Schedule, Error> = .success(MockHelpers.createMockSchedule())
    
    // MARK: - Call Tracking
    /// 각 유즈케이스 메소드가 호출된 횟수를 기록합니다.
    var getWeeklySchedulesCallCount = 0
    var getMonthlySchedulesCallCount = 0
    var getSchedulesForDateRangeCallCount = 0
    var createScheduleCallCount = 0
    var updateScheduleCallCount = 0
    var deleteScheduleCallCount = 0
    var getRecommendedTagsCallCount = 0
    var updateScheduleStateCallCount = 0
    
    // MARK: - Protocol Implementation
    /// 주간 스케줄 조회 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func getWeeklySchedules(for date: Date) async throws -> [DailySchedule] {
        getWeeklySchedulesCallCount += 1
        return try getWeeklySchedulesResult.get()
    }
    
    /// 월간 스케줄 조회 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func getMonthlySchedules(for date: Date) async throws -> [DailySchedule] {
        getMonthlySchedulesCallCount += 1
        return try getMonthlySchedulesResult.get()
    }
    
    /// 기간 스케줄 조회 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func getSchedulesForDateRange(startDate: Date, endDate: Date) async throws -> [DailySchedule] {
        getSchedulesForDateRangeCallCount += 1
        return try getSchedulesForDateRangeResult.get()
    }
    
    /// 스케줄 생성 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func createSchedule(title: String, date: Date, startTime: Date, endTime: Date, category: ScheduleCategory, temperature: Int, allDay: Bool, alarmOption: AlarmOption) async throws -> Schedule {
        createScheduleCallCount += 1
        return try createScheduleResult.get()
    }
    
    /// 스케줄 수정 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func updateSchedule(id: String, title: String, startTime: Date, endTime: Date, category: ScheduleCategory, temperature: Int, allDay: Bool, alarmOption: AlarmOption) async throws -> Schedule {
        updateScheduleCallCount += 1
        return try updateScheduleResult.get()
    }
    
    /// 스케줄 삭제 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func deleteSchedule(id: String) async throws {
        deleteScheduleCallCount += 1
        try deleteScheduleResult.get()
    }
    
    /// 추천 태그 조회 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func getRecommendedTags() async throws -> RecommendTagResponse {
        getRecommendedTagsCallCount += 1
        return try getRecommendedTagsResult.get()
    }
    
    /// 스케줄 완료 상태 변경 동작을 시뮬레이션하고 미리 설정된 결과를 반환합니다.
    func updateScheduleState(id: String, isComplete: Bool) async throws -> Schedule {
        updateScheduleStateCallCount += 1
        return try updateScheduleStateResult.get()
    }
}

// MARK: - Mock Helpers
/// 테스트에 필요한 다양한 종류의 모의 데이터를 쉽게 생성하기 위한 정적 헬퍼 메소드들을 제공합니다.
enum MockHelpers {
    /// 기본 모의 `Schedule` 객체를 생성합니다.
    static func createMockSchedule(id: String = "mock-schedule", title: String = "Mock Schedule", category: ScheduleCategory = .company, temperature: Int = 50, completed: Bool = false) -> Schedule {
        Schedule(id: id, title: title, startTime: Date(), endTime: Date().addingTimeInterval(3600), category: category, temperature: temperature, allDay: false, alarmOption: .none, completed: completed)
    }
    
    /// 기본 모의 `RecommendTagResponse` 객체를 생성합니다.
    static func createMockRecommendTags() -> RecommendTagResponse {
        RecommendTagResponse(result: "SUCCESS", data: RecommendTagData(firstRecommendTag: RecommendTag(content: "운동하기"), secondRecommendTag: RecommendTag(content: "회의하기"), thirdRecommendTag: RecommendTag(content: "휴식하기")), error: nil)
    }
    
    /// 기본 모의 `DailySchedule` 객체를 생성합니다.
    static func createMockDailySchedule(date: String, schedules: [Schedule] = []) -> DailySchedule {
        let defaultSchedules = schedules.isEmpty ? [createMockSchedule()] : schedules
        return DailySchedule(date: date, dailyTemperature: 50, schedules: defaultSchedules)
    }
}

// MARK: - Result Extension
extension Result {
    /// `Result` 타입의 값을 추출하거나, 실패 시 에러를 던지는 편의 메소드입니다.
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
