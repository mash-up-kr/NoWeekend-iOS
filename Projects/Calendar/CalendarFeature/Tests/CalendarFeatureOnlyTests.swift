//
//  CalendarFeatureTests.swift
//  CalendarFeatureTests
//
//  Created by 이지훈 on 7/24/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import XCTest
import Combine
import SwiftUI
@testable import CalendarFeature
@testable import CalendarDomain
@testable import DesignSystem
@testable import DIContainer
import Foundation

// MARK: - Feature Layer 단위 테스트 (Store 상태 관리)
/**
 CalendarStore의 상태 관리 로직을 단위 테스트로 검증하는 클래스
 DI 의존성 없이 Store의 순수한 상태 변경 로직에 집중
 
 주요 테스트 영역:
 - 초기 상태 검증
 - 상태 변경 로직의 정확성
 - Navigation Effect 발생 조건
 - Computed Property의 올바른 계산
 */
@MainActor
final class CalendarFeatureTests: XCTestCase {
    
    private var sut: CalendarStore!
    private var cancellables: Set<AnyCancellable>!
    private var capturedEffects: [CalendarEffect] = []
    private var mockUseCase: MockCalendarUseCase!
    
    override func setUp() {
        super.setUp()
        
        setupTestDI()
        
        sut = CalendarStore()
        cancellables = Set<AnyCancellable>()
        capturedEffects = []
        
        // Effect 스트림 구독
        sut.effect
            .sink { [weak self] effect in
                self?.capturedEffects.append(effect)
            }
            .store(in: &cancellables)
    }
    
    override func tearDown() {
        cancellables?.removeAll()
        capturedEffects.removeAll()
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    /**
     테스트용 DI Container 설정
     각 테스트마다 격리된 Mock UseCase 인스턴스 제공
     */
    private func setupTestDI() {
        mockUseCase = MockCalendarUseCase()
        
        DIContainer.shared.container.register(CalendarUseCaseProtocol.self) { _ in
            return self.mockUseCase
        }.inObjectScope(.transient)
    }
    
    // MARK: - 초기 상태 테스트
    
    /**
     CalendarStore 초기 상태 검증
     
     검증 사항:
     - 모든 초기값이 예상된 기본값으로 설정됨
     - 컬렉션 타입들이 빈 상태로 초기화됨
     - Boolean 플래그들이 올바른 기본값을 가짐
     */
    func test_initialState_hasCorrectDefaults() {
        // Then: 모든 초기 상태값 검증
        XCTAssertEqual(sut.state.selectedToggle, .week, "초기 토글은 주 단위여야 함")
        XCTAssertEqual(sut.state.dailySchedules.count, 0, "초기 스케줄 목록은 비어있어야 함")
        XCTAssertEqual(sut.state.todoItems.count, 0, "초기 할일 목록은 비어있어야 함")
        XCTAssertEqual(sut.state.recommendedCategories.count, 0, "초기 추천 카테고리는 비어있어야 함")
        XCTAssertFalse(sut.state.showTaskEditSheet, "초기에는 할일 수정 시트가 숨겨져야 함")
        XCTAssertFalse(sut.state.showCategorySelection, "초기에는 카테고리 선택이 숨겨져야 함")
        XCTAssertEqual(sut.state.scrollOffset, 0, "초기 스크롤 오프셋은 0이어야 함")
        XCTAssertFalse(sut.state.isScrolling, "초기에는 스크롤 중이 아니어야 함")
        XCTAssertNil(sut.state.selectedTaskIndex, "초기에는 선택된 할일이 없어야 함")
        XCTAssertFalse(sut.state.isLoading, "초기에는 로딩 상태가 아니어야 함")
    }
    
    /**
     State 직접 수정 로직 검증
     
     시나리오:
     - updateState 메서드를 통한 다양한 상태값 변경
     - 변경된 값들이 올바르게 반영되는지 확인
     
     검증 사항:
     - 각 상태 프로퍼티가 설정한 값으로 정확히 변경됨
     - 날짜 비교 시 적절한 정밀도로 검증됨
     */
    func test_updateState_modifiesStateCorrectly() {
        // Given: 변경할 상태값들 준비
        let newToggle = CalendarNavigationBar.ToggleOption.month
        let testDate = createDate(year: 2025, month: 8, day: 15)
        
        // When: 상태 직접 수정
        sut.updateState { state in
            state.selectedToggle = newToggle
            state.selectedDate = testDate
            state.showCategorySelection = true
            state.scrollOffset = 100
            state.isScrolling = true
        }
        
        // Then: 모든 변경사항 검증
        XCTAssertEqual(sut.state.selectedToggle, newToggle, "토글 상태가 올바르게 변경되어야 함")
        XCTAssertEqual(sut.state.selectedDate.timeIntervalSince1970, testDate.timeIntervalSince1970, accuracy: 1,
                      "선택된 날짜가 올바르게 변경되어야 함")
        XCTAssertTrue(sut.state.showCategorySelection, "카테고리 선택 표시가 활성화되어야 함")
        XCTAssertEqual(sut.state.scrollOffset, 100, "스크롤 오프셋이 올바르게 설정되어야 함")
        XCTAssertTrue(sut.state.isScrolling, "스크롤 상태가 활성화되어야 함")
    }
    
    // MARK: - Navigation Effect 테스트
    
    /**
     월 단위 모드에서 날짜 선택 시 상세 화면 네비게이션 테스트
     
     시나리오:
     - 캘린더가 월 단위 모드일 때 특정 날짜 선택
     - 해당 날짜의 상세 화면으로 네비게이션 Effect 발생 확인
     
     검증 사항:
     - navigateToDateDetail Effect가 정확히 한 번 발생함
     - Effect에 포함된 날짜가 선택한 날짜와 일치함
     */
    func test_dateSelected_withMonthToggle_navigatesToDateDetail() async {
        // Given: 월 단위 모드로 설정
        sut.updateState { state in
            state.selectedToggle = .month
        }
        let testDate = createDate(year: 2025, month: 8, day: 15)
        
        // When: 특정 날짜 선택
        sut.send(.dateSelected(testDate))
        await waitForAsyncOperations()
        
        // Then: 네비게이션 Effect 검증
        XCTAssertEqual(capturedEffects.count, 1, "정확히 하나의 Effect가 발생해야 함")
        
        if case .navigateToDateDetail(let date) = capturedEffects.first {
            XCTAssertEqual(date.timeIntervalSince1970, testDate.timeIntervalSince1970, accuracy: 1,
                          "Effect의 날짜가 선택한 날짜와 일치해야 함")
        } else {
            XCTFail("navigateToDateDetail Effect가 발생해야 함, 실제: \(capturedEffects)")
        }
    }
    
    /**
     직접 입력 버튼 탭 시 할일 생성 화면 네비게이션 테스트
     
     시나리오:
     - 카테고리 선택 모드에서 "직접 입력" 버튼 탭
     - 카테고리 선택 모드 종료 및 할일 생성 화면 네비게이션
     
     검증 사항:
     - 카테고리 선택 상태가 false로 변경됨
     - navigateToTaskCreate Effect가 올바른 날짜와 함께 발생함
     */
    func test_directInputTapped_navigatesToTaskCreate() async {
        // Given: 카테고리 선택 모드 활성화 및 날짜 설정
        let testDate = createDate(year: 2025, month: 7, day: 24)
        sut.updateState { state in
            state.showCategorySelection = true
            state.selectedDate = testDate
        }
        
        // When: 직접 입력 버튼 탭
        sut.send(.directInputTapped)
        await waitForAsyncOperations()
        
        // Then: 상태 변경 및 네비게이션 Effect 검증
        XCTAssertFalse(sut.state.showCategorySelection, "카테고리 선택이 비활성화되어야 함")
        XCTAssertEqual(capturedEffects.count, 1, "정확히 하나의 Effect가 발생해야 함")
        
        if case .navigateToTaskCreate(let date) = capturedEffects.first {
            XCTAssertEqual(date.timeIntervalSince1970, testDate.timeIntervalSince1970, accuracy: 1,
                          "Effect의 날짜가 현재 선택된 날짜와 일치해야 함")
        } else {
            XCTFail("navigateToTaskCreate Effect가 발생해야 함, 실제: \(capturedEffects)")
        }
    }
    
    // MARK: - 할일 관리 테스트
    
    /**
     할일 더보기 버튼 탭 시 수정 시트 표시 테스트
     
     시나리오:
     - 하나의 할일이 있는 상태에서 더보기 버튼 탭
     - 할일 수정 시트 표시 및 선택된 할일 인덱스 설정
     
     검증 사항:
     - 할일 수정 시트가 표시됨
     - 선택된 할일 인덱스가 올바르게 설정됨
     */
    func test_taskMoreTapped_showsTaskEditSheet() async {
        // Given: 할일 목록 준비
        sut.updateState { state in
            state.todoItems = [createMockTodoItem(id: 1, title: "테스트 할일")]
        }
        
        // When: 더보기 버튼 탭
        sut.send(.taskMoreTapped(0))
        await waitForAsyncOperations()
        
        // Then: 수정 시트 표시 상태 검증
        XCTAssertTrue(sut.state.showTaskEditSheet, "할일 수정 시트가 표시되어야 함")
        XCTAssertEqual(sut.state.selectedTaskIndex, 0, "선택된 할일 인덱스가 0이어야 함")
    }
    
    /**
     잘못된 인덱스로 할일 더보기 버튼 탭 시 안전성 테스트
     
     시나리오:
     - 빈 할일 목록에서 존재하지 않는 인덱스로 더보기 버튼 탭
     - 시스템이 크래시 없이 안전하게 처리하는지 확인
     
     검증 사항:
     - 애플리케이션이 크래시하지 않음
     - 수정 시트가 표시되지 않음
     - 선택된 할일 인덱스가 설정되지 않음
     */
    func test_taskMoreTapped_withInvalidIndex_handlesGracefully() async {
        // Given: 빈 할일 목록
        sut.updateState { state in
            state.todoItems = []
        }
        
        // When: 존재하지 않는 인덱스로 더보기 버튼 탭
        sut.send(.taskMoreTapped(999))
        await waitForAsyncOperations()
        
        // Then: 안전한 처리 검증 (크래시 없이 정상 동작)
        XCTAssertFalse(sut.state.showTaskEditSheet, "수정 시트가 표시되지 않아야 함")
        XCTAssertNil(sut.state.selectedTaskIndex, "선택된 할일 인덱스가 설정되지 않아야 함")
    }
    
    // MARK: - 카테고리 선택 테스트
    
    /**
     카테고리 선택 토글 동작 테스트
     
     시나리오:
     - 초기 상태(비활성화)에서 카테고리 선택 토글
     - 상태가 활성화로 변경되는지 확인
     
     검증 사항:
     - 카테고리 선택 상태가 토글됨
     */
    func test_categorySelectionToggled_togglesState() async {
        // Given: 초기 상태 (카테고리 선택 비활성화)
        XCTAssertFalse(sut.state.showCategorySelection, "초기에는 카테고리 선택이 비활성화되어야 함")
        
        // When: 카테고리 선택 토글
        sut.send(.categorySelectionToggled)
        await waitForAsyncOperations()
        
        // Then: 상태 변경 검증
        XCTAssertTrue(sut.state.showCategorySelection, "카테고리 선택이 활성화되어야 함")
    }
    
    // MARK: - Computed Property 테스트
    
    /**
     플로팅 버튼 확장 상태 계산 로직 테스트
     
     시나리오:
     - 스크롤 오프셋이 0이고 스크롤 중이 아닌 상태
     - 플로팅 버튼이 확장 상태여야 함
     
     검증 사항:
     - isFloatingButtonExpanded가 true를 반환함
     */
    func test_isFloatingButtonExpanded_withZeroOffsetAndNotScrolling_returnsTrue() {
        // Given: 플로팅 버튼 확장 조건 설정
        sut.updateState { state in
            state.scrollOffset = 0
            state.isScrolling = false
        }
        
        // Then: 확장 상태 검증
        XCTAssertTrue(sut.state.isFloatingButtonExpanded, "스크롤 최상단에서 플로팅 버튼이 확장되어야 함")
    }
    
    /**
     현재 날짜 문자열 포맷 검증 테스트
     
     시나리오:
     - 특정 날짜를 선택된 날짜로 설정
     - 날짜 문자열이 "yyyy년 M월" 형식으로 올바르게 포맷팅되는지 확인
     
     검증 사항:
     - currentDateString이 예상된 형식으로 반환됨
     */
    func test_currentDateString_returnsCorrectFormat() {
        // Given: 특정 날짜 설정
        let testDate = createDate(year: 2025, month: 7, day: 24)
        sut.updateState { state in
            state.selectedDate = testDate
        }
        
        // Then: 날짜 문자열 포맷 검증
        XCTAssertEqual(sut.state.currentDateString, "2025년 7월", "날짜가 올바른 형식으로 포맷되어야 함")
    }
    
    // MARK: - 헬퍼 메서드
    
    /**
     비동기 작업 완료를 위한 최소 대기 시간
     */
    private func waitForAsyncOperations() async {
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
    }
    
    /**
     테스트용 날짜 생성 (서울 시간대 기준)
     */
    private func createDate(year: Int, month: Int, day: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components) ?? Date()
    }
    
    /**
     테스트용 Mock TodoItem 생성
     */
    private func createMockTodoItem(id: Int, title: String, category: String? = nil, scheduleId: String? = nil) -> DesignSystem.TodoItem {
        let todoCategory = category.map {
            DesignSystem.TodoCategory(name: $0, color: DS.Colors.TaskItem.orange)
        }
        
        return DesignSystem.TodoItem(
            id: id,
            title: title,
            isCompleted: false,
            category: todoCategory,
            time: "오전 9:00",
            scheduleId: scheduleId
        )
    }
}
