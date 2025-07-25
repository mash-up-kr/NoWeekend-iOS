//
//  CalendarDomainTests.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/24/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//


//
//  CalendarDomainTests.swift
//  CalendarFeatureTests
//
//  Created by 이지훈 on 7/24/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import XCTest
@testable import CalendarFeature
@testable import CalendarDomain
import Foundation

// MARK: - Domain Layer Tests (UseCase)
/**
 `CalendarUseCase`의 로직을 검증하는 테스트 클래스입니다.
 UseCase가 Repository를 올바르게 호출하고, 전달된 데이터를 적절히 가공하며, 에러를 잘 처리하는지 확인합니다.
 */
final class CalendarDomainTests: XCTestCase {
    
    /// 테스트 대상 시스템(System Under Test)으로, `CalendarUseCase`의 인스턴스입니다.
    private var sut: CalendarUseCase!
    /// `CalendarUseCase`가 의존하는 Repository의 Mock 객체입니다.
    private var mockRepository: MockCalendarRepository!
    
    /**
     각 테스트 케이스가 실행되기 전에 호출됩니다.
     테스트에 필요한 `mockRepository`와 `sut`를 초기화합니다.
     */
    override func setUp() {
        super.setUp()
        mockRepository = MockCalendarRepository()
        sut = CalendarUseCase(calendarRepository: mockRepository)
    }
    
    /**
     각 테스트 케이스가 완료된 후에 호출됩니다.
     사용한 객체들을 nil로 만들어 메모리에서 해제하고, 테스트 간의 독립성을 보장합니다.
     */
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Week Range Calculation Tests
    /**
     `getWeeklySchedules` 호출 시, 주어진 날짜에 대해 정확한 주(월요일 ~ 일요일)의 시작일과 종료일을 계산하여 리포지토리를 호출하는지 테스트합니다.
     */
    func test_getWeeklySchedules_shouldCalculateCorrectWeekRange() async throws {
        // Given: 테스트를 위한 특정 날짜(2025년 7월 24일 목요일)와 Mock 데이터 설정
        let testDate = createDate(year: 2025, month: 7, day: 24) // 목요일
        
        mockRepository.mockSchedules = [
            createMockDailySchedule(date: "2025-07-24")
        ]
        
        // When: 주간 스케줄을 조회하는 UseCase 메소드 실행
        let result = try await sut.getWeeklySchedules(for: testDate)
        
        // Then: 리포지토리가 예상대로 호출되었는지, 파라미터가 정확한지 검증
        XCTAssertEqual(mockRepository.getSchedulesCallCount, 1, "리포지토리의 getSchedules가 한 번만 호출되어야 합니다.")
        
        guard let params = mockRepository.lastGetSchedulesParams else {
            XCTFail("리포지토리 메소드는 파라미터와 함께 호출되어야 합니다.")
            return
        }
        
        // 2025년 7월 24일(목)이 속한 주는 7월 21일(월)부터 7월 27일(일)까지여야 합니다.
        XCTAssertEqual(params.startDate, "2025-07-21", "계산된 주 시작일이 정확해야 합니다.")
        XCTAssertEqual(params.endDate, "2025-07-27", "계산된 주 종료일이 정확해야 합니다.")
        XCTAssertEqual(result.count, 1, "반환된 결과의 수가 Mock 데이터와 일치해야 합니다.")
    }
    
    // MARK: - Schedule CRUD Tests
    /**
     `createSchedule` 호출 시, 모든 파라미터를 정확하게 `CreateScheduleRequest` 객체로 만들어 리포지토리에 전달하는지 테스트합니다.
     */
    func test_createSchedule_shouldCallRepositoryWithCorrectParameters() async throws {
        // Given: 스케줄 생성을 위한 파라미터와 예상 결과 설정
        let title = "테스트 미팅"
        let date = createDate(year: 2025, month: 7, day: 24)
        let startTime = createDateTime(year: 2025, month: 7, day: 24, hour: 14, minute: 0)
        let endTime = createDateTime(year: 2025, month: 7, day: 24, hour: 15, minute: 0)
        let category = ScheduleCategory.company
        let temperature = 75
        let allDay = false
        let alarmOption = AlarmOption.fifteenMinutesBefore
        
        let expectedSchedule = Schedule(id: "test-schedule-1", title: title, startTime: startTime, endTime: endTime, category: category, temperature: temperature, allDay: allDay, alarmOption: alarmOption, completed: false)
        
        mockRepository.mockCreatedSchedule = expectedSchedule
        
        // When: 스케줄 생성 UseCase 메소드 실행
        let result = try await sut.createSchedule(title: title, date: date, startTime: startTime, endTime: endTime, category: category, temperature: temperature, allDay: allDay, alarmOption: alarmOption)
        
        // Then: 리포지토리 호출 및 전달된 데이터 검증
        XCTAssertEqual(mockRepository.createScheduleCallCount, 1, "리포지토리의 createSchedule이 한 번만 호출되어야 합니다.")
        
        guard let request = mockRepository.lastCreatedScheduleRequest else {
            XCTFail("생성된 스케줄 요청 객체가 리포지토리에 전달되어야 합니다.")
            return
        }
        
        XCTAssertEqual(request.title, title)
        XCTAssertEqual(request.category, category)
        XCTAssertEqual(request.temperature, temperature)
        XCTAssertEqual(result.id, expectedSchedule.id, "반환된 결과가 Mock 객체와 일치해야 합니다.")
    }
    
    // MARK: - Error Handling Tests
    /**
     리포지토리에서 에러가 발생했을 때, UseCase가 해당 에러를 호출한 쪽으로 올바르게 다시 던지는지(re-throw) 테스트합니다.
     */
    func test_createSchedule_shouldThrowErrorWhenRepositoryFails() async {
        // Given: 리포지토리가 에러를 발생시키도록 설정
        mockRepository.shouldThrowError = true
        
        // When & Then: 에러가 발생할 것을 예상하고 테스트 실행
        do {
            _ = try await sut.createSchedule(title: "Test", date: Date(), startTime: Date(), endTime: Date().addingTimeInterval(3600), category: .company, temperature: 50, allDay: false, alarmOption: .none)
            XCTFail("예외가 발생해야 하지만, 정상적으로 실행되었습니다.")
        } catch {
            // 에러가 발생하더라도 리포지토리 호출 시도는 이루어졌어야 합니다.
            XCTAssertEqual(mockRepository.createScheduleCallCount, 1, "에러가 발생하더라도 리포지토리 메소드는 호출되어야 합니다.")
            XCTAssert(error is NSError, "던져진 에러가 예상된 타입이어야 합니다.")
        }
    }
}

// MARK: - Test Helpers
/**
 테스트 코드의 가독성과 재사용성을 높이기 위한 헬퍼 메소드들을 모아둔 private extension입니다.
 */
private extension CalendarDomainTests {
    /// 특정 년/월/일로 `Date` 객체를 생성합니다. (시간은 0시)
    func createDate(year: Int, month: Int, day: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components) ?? Date()
    }
    
    /// 특정 년/월/일/시/분으로 `Date` 객체를 생성합니다.
    func createDateTime(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return calendar.date(from: components) ?? Date()
    }
    
    /// 테스트용 `DailySchedule` 모의 객체를 생성합니다.
    func createMockDailySchedule(date: String) -> DailySchedule {
        let mockSchedule = Schedule(id: "mock-schedule", title: "Mock Schedule", startTime: Date(), endTime: Date().addingTimeInterval(3600), category: .company, temperature: 50, allDay: false, alarmOption: .none, completed: false)
        
        return DailySchedule(date: date, dailyTemperature: 50, schedules: [mockSchedule])
    }
}
